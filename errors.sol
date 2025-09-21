// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ErrorTriageExercise {
    // Return absolute differences between consecutive numbers
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        uint ;
        results[0] = _a > _b ? _a - _b : _b - _a;
        results[1] = _b > _c ? _b - _c : _c - _b;
        results[2] = _c > _d ? _c - _d : _d - _c;
        return results;
    }

    // Apply positive or negative modifier to base value
    function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint returnValue) {
        if (_modifier > 0) {
            return _base + uint(_modifier);
        }
        return _base - uint(-_modifier);
    }

    uint[] arr;

    // Pop last element and return it
    function popWithReturn() public returns (uint returnNum) {
        if (arr.length > 0) {
            uint result = arr[arr.length - 1];
            arr.pop();
            return result;
        }
    }

    // Add element to array
    function addToArr(uint _num) public {
        arr.push(_num);
    }

    // View entire array
    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    // Clear array
    function resetArr() public {
        delete arr;
    }
}
