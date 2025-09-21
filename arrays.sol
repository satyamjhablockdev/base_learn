// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ArraysExercise {
    // Stored arrays
    uint[] numbers = [1,2,3,4,5,6,7,8,9,10]; // preset numbers
    uint[] timestamps;                      // saved timestamps
    address[] senders;                      // who saved each timestamp

    uint256 constant Y2K = 946702800;       // Unix time for 1 Jan 2000

    // Return a copy of numbers array
    function getNumbers() external view returns (uint[] memory) {
        uint[] memory results = new uint[](numbers.length);
        for (uint i = 0; i < numbers.length; i++) {
            results[i] = numbers[i];
        }
        return results;
    }

    // Reset numbers to original values
    function resetNumbers() public {
        numbers = [1,2,3,4,5,6,7,8,9,10];
    }

    // Append values to numbers
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Save a timestamp and caller address
    function saveTimestamp(uint _unixTimestamp) public {
        timestamps.push(_unixTimestamp);
        senders.push(msg.sender);
    }

    // Return all timestamps and senders after year 2000
    function afterY2K() public view returns (uint256[] memory, address[] memory) {
        uint256 count;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > Y2K) count++;
        }

        uint256[] memory tAfter = new uint256[](count);
        address[] memory sAfter = new address[](count);
        uint256 index;
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > Y2K) {
                tAfter[index] = timestamps[i];
                sAfter[index] = senders[i];
                index++;
            }
        }
        return (tAfter, sAfter);
    }

    // Clear senders array
    function resetSenders() public {
        delete senders;
    }

    // Clear timestamps array
    function resetTimestamps() public {
        delete timestamps;
    }
}
