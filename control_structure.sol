// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BasicMath
 * @notice Simple demonstration of safe addition and subtraction in Solidity.
 * @dev
 * - Shows how to manually detect overflow and underflow without relying on
 *   Solidity's built-in checked arithmetic (useful for educational purposes).
 * - Since Solidity 0.8.x automatically reverts on overflow/underflow,
 *   this example instead returns a boolean flag (`error`) so callers can
 *   see whether a calculation would have failed in an unchecked context.
 *
 * ------------------------------------------------------------------------
 * HOW IT WORKS
 * adder(_a, _b):
 *   1. Compute `MAX_INT - _a`.
 *   2. If `_b` is greater than this value, adding would exceed the maximum
 *      representable uint256, so return (0, true) to signal an overflow.
 *   3. Otherwise, return the sum and a false flag.
 *
 * subtractor(_a, _b):
 *   1. If `_b` is greater than `_a`, subtraction would go negative (underflow).
 *   2. Return (0, true) if underflow would occur; else return the difference
 *      and a false flag.
 *
 * ------------------------------------------------------------------------
 * EXAMPLES
 * adder(2, 3)           -> (5, false)
 * adder(type(uint256).max, 1) -> (0, true)  // overflow
 *
 * subtractor(10, 4)     -> (6, false)
 * subtractor(3, 5)      -> (0, true)       // underflow
 */
contract BasicMath {
    /// @dev The largest unsigned integer Solidity can handle (2^256 - 1).
    uint256 constant MAX_INT = type(uint256).max;

    /**
     * @notice Safely add two unsigned integers.
     * @param _a First operand.
     * @param _b Second operand.
     * @return sum   The computed sum if no overflow occurred; 0 if overflow.
     * @return error Boolean flag set to true if overflow would have occurred.
     *
     * Logic:
     * - If `_b` > `MAX_INT - _a`, then `_a + _b` would exceed the uint256 limit.
     * - In that case, return (0, true).
     * - Otherwise return (_a + _b, false).
     */
    function adder(uint256 _a, uint256 _b) external pure returns (uint256 sum, bool error) {
        // Check for potential overflow before performing addition
        if (_b > MAX_INT - _a) {
            return (0, true); // Overflow occurred
        }
        // Safe to add
        return (_a + _b, false);
    }

    /**
     * @notice Safely subtract one unsigned integer from another.
     * @param _a Minuend (the number to subtract from).
     * @param _b Subtrahend (the number to subtract).
     * @return difference The computed difference if no underflow occurred; 0 if underflow.
     * @return error      Boolean flag set to true if underflow would have occurred.
     *
     * Logic:
     * - If `_b` > `_a`, subtraction would produce a negative number,
     *   which cannot be represented as uint256.
     * - In that case, return (0, true).
     * - Otherwise return (_a - _b, false).
     */
    function subtractor(uint256 _a, uint256 _b) external pure returns (uint256 difference, bool error) {
        // Check for potential underflow before performing subtraction
        if (_b > _a) {
            return (0, true); // Underflow occurred
        }
        // Safe to subtract
        return (_a - _b, false);
    }
}
