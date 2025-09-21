// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Base employee with id and manager info
abstract contract Employee {
    uint public idNumber;
    uint public managerId;

    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    // Must return yearly cost
    function getAnnualCost() public virtual returns (uint);
}

// Fixed-salary employee
contract Salaried is Employee {
    uint public annualSalary;

    constructor(uint _idNumber, uint _managerId, uint _annualSalary)
        Employee(_idNumber, _managerId)
    {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view override returns (uint) {
        return annualSalary;
    }
}

// Hourly employee
contract Hourly is Employee {
    uint public hourlyRate;

    constructor(uint _idNumber, uint _managerId, uint _hourlyRate)
        Employee(_idNumber, _managerId)
    {
        hourlyRate = _hourlyRate;
    }

    // 2080 work hours assumed per year
    function getAnnualCost() public view override returns (uint) {
        return hourlyRate * 2080;
    }
}

// Manager that keeps a list of employee IDs
contract Manager {
    uint[] public employeeIds;

    function addReport(uint _reportId) public {
        employeeIds.push(_reportId);
    }

    function resetReports() public {
        delete employeeIds;
    }
}

// Salesperson is an hourly employee
contract Salesperson is Hourly {
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate)
        Hourly(_idNumber, _managerId, _hourlyRate)
    {}
}

// Engineering manager is salaried and can manage reports
contract EngineeringManager is Salaried, Manager {
    constructor(uint _idNumber, uint _managerId, uint _annualSalary)
        Salaried(_idNumber, _managerId, _annualSalary)
    {}
}

// Stores addresses of deployed employee contracts
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
