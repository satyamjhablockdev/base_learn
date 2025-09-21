// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EmployeeStorage {
    // Private data
    uint16 private shares;   // employee shares
    uint32 private salary;   // employee monthly salary
    // Public data
    uint256 public idNumber; // employee ID
    string  public name;     // employee name

    // Set initial values on deployment
    constructor(uint16 _shares, string memory _name, uint32 _salary, uint _idNumber) {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }

    // Return private shares
    function viewShares() public view returns (uint16) {
        return shares;
    }

    // Return private salary
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    // Custom error for exceeding share limit
    error TooManyShares(uint16 _shares);

    // Add new shares, limit total to 5000
    function grantShares(uint16 _newShares) public {
        if (_newShares > 5000) {
            revert("Too many shares");
        } else if (shares + _newShares > 5000) {
            revert TooManyShares(shares + _newShares);
        }
        shares += _newShares;
    }

    // Read raw storage slot value
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    // Reset shares to 1000
    function debugResetShares() public {
        shares = 1000;
    }
}
