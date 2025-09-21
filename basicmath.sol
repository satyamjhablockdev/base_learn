// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicMath {
    // Maximum uint256 value for overflow check
    uint256 constant MAX_INT = type(uint256).max;

    // Add two numbers, return sum and error flag if overflow
    function adder(uint256 _a, uint256 _b) external pure returns (uint256 sum, bool error) {
        if (_b > MAX_INT - _a) {
            return (0, true); // overflow
        }
        return (_a + _b, false);
    }

    // Subtract two numbers, return difference and error flag if underflow
    function subtractor(uint256 _a, uint256 _b) external pure returns (uint256 difference, bool error) {
        if (_b > _a) {
            return (0, true); // underflow
        }
        return (_a - _b, false);
    }
}
