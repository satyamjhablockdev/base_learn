// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/**
 * @title ControlStructures
 * @notice Demonstrates common control-flow patterns in Solidity (if/else, guards, custom errors).
 * @dev
 * - Functions are marked `pure`, so they don't read or write contract state (cheap & deterministic).
 * - Uses custom errors (introduced in Solidity 0.8.4) which are more gas-efficient than revert strings
 *   and make debugging easier by carrying structured data.
 *
 * ──────────────────────────────────────────────────────────────────────────────
 * QUICK MAP
 * fizzBuzz(_number):
 *   - "FizzBuzz" if divisible by 3 and 5
 *   - "Fizz"     if divisible by 3
 *   - "Buzz"     if divisible by 5
 *   - "Splat"    otherwise
 *
 * doNotDisturb(_time in HHMM, e.g., 930 or 1815):
 *   - Asserts _time < 2400 (basic upper bound; does NOT validate minutes)
 *   - Reverts AfterHours if _time > 2200 or _time < 800
 *   - Reverts AtLunch for 1200–1299 (12:00–12:59)
 *   - "Morning!"   for 0800–1159
 *   - "Afternoon!" for 1300–1759
 *   - "Evening!"   for 1800–2200
 * ──────────────────────────────────────────────────────────────────────────────
 */
contract ControlStructures {
    // ─────────────────────────────────────────────────────────────────────
    // Custom Errors
    // ─────────────────────────────────────────────────────────────────────

    /**
     * @notice Thrown when a provided time falls outside business hours.
     * @param time The HHMM integer that caused the revert (e.g., 2230, 0745).
     */
    error AfterHours(uint256 time);

    /**
     * @notice Thrown when the provided time falls during the 12:00–12:59 lunch period.
     */
    error AtLunch();

    // ─────────────────────────────────────────────────────────────────────
    // fizzBuzz
    // ─────────────────────────────────────────────────────────────────────

    /**
     * @notice Classic FizzBuzz: categorize a number by divisibility.
     * @dev Order of checks matters: test (3 AND 5) first to catch numbers like 15, 30, 45, ...
     * @param _number The number to classify.
     * @return response One of "FizzBuzz", "Fizz", "Buzz", or "Splat".
     *
     * Examples:
     * - 15 → "FizzBuzz"
     * - 9  → "Fizz"
     * - 10 → "Buzz"
     * - 7  → "Splat"
     */
    function fizzBuzz(uint256 _number) public pure returns (string memory response) {
        // Check if the number is divisible by both 3 and 5 first.
        // This must come before the single-divisor checks; otherwise 15 would match "Fizz" or "Buzz" prematurely.
        if (_number % 3 == 0 && _number % 5 == 0) {
            return "FizzBuzz"; // e.g., 15, 30, 45
        } 
        // Next, check divisibility by only 3 (numbers like 3, 6, 9, 12, ...).
        else if (_number % 3 == 0) {
            return "Fizz";
        } 
        // Then, check divisibility by only 5 (numbers like 5, 10, 20, ...).
        else if (_number % 5 == 0) {
            return "Buzz";
        } 
        // If it’s neither divisible by 3 nor 5, return the default label.
        else {
            return "Splat";
        }
    }

    // ─────────────────────────────────────────────────────────────────────
    // doNotDisturb
    // ─────────────────────────────────────────────────────────────────────

    /**
     * @notice Return a greeting if within business hours; otherwise revert with a custom error.
     * @dev
     * - `_time` is a 24-hour HHMM integer, e.g., 0800, 0930, 1745, 2215. (Pass 930 as 930, not "09:30".)
     * - Uses `assert(_time < 2400)` as a basic sanity check against impossible hours. Note that this
     *   does NOT validate minutes; e.g., 2360 passes the assert but is still treated by the later logic.
     * - Ranges are inclusive of their endpoints unless noted.
     *
     * Ranges:
     * - AfterHours:    _time > 2200 OR _time < 800  → revert AfterHours(_time)
     * - Lunch:         1200 ≤ _time ≤ 1299          → revert AtLunch()
     * - Morning:       0800 ≤ _time ≤ 1159          → "Morning!"
     * - Afternoon:     1300 ≤ _time ≤ 1799          → "Afternoon!"
     * - Evening:       1800 ≤ _time ≤ 2200          → "Evening!"
     *
     * Boundary notes:
     * - 0759 → AfterHours (too early)
     * - 0800 → Morning!
     * - 1159 → Morning!
     * - 1200–1299 → AtLunch()
     * - 1300 → Afternoon!
     * - 1759 → Afternoon!
     * - 1800 → Evening!
     * - 2200 → Evening!
     * - 2201 → AfterHours (too late)
     *
     * @param _time Time as HHMM (0000–2359).
     * @return result Greeting string if within a greeting window; otherwise the function reverts.
     */
    function doNotDisturb(uint256 _time) public pure returns (string memory result) {
        // ── Guard: basic upper-bound sanity check.
        // Using `assert` communicates that values ≥ 2400 violate an assumed invariant.
        // (In 0.8.x, `assert` consumes remaining gas on failure—use `require` for user input validation if desired.
        // We keep `assert` here to preserve the original function exactly as requested.)
        assert(_time < 2400);

        // ── Outside business hours?
        // If time is strictly later than 22:00 (2200) OR earlier than 08:00 (0800), we are unavailable.
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time); // Provide the problematic time to aid debugging/UIs.
        } 
        // ── Lunch window: 12:00–12:59 inclusive
        else if (_time >= 1200 && _time <= 1299) {
            revert AtLunch(); // Explicit signal that we're briefly unavailable at lunch.
        } 
        // ── Morning window: 08:00–11:59
        else if (_time >= 800 && _time <= 1199) {
            return "Morning!"; // Friendly, fast path when available.
        } 
        // ── Afternoon window: 13:00–17:59
        else if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        } 
        // ── Evening window: 18:00–22:00 inclusive
        else if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        // Note: All valid times are covered by the above branches.
        // If control ever reached here, it would imply a gap in the ranges,
        // but current ranges are exhaustive for 0800–2200 excluding 1200–1299.
    }
}
