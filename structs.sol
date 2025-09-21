// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract GarageManager {
    // Each user address maps to their array of cars
    mapping(address => Car[]) private garages;

    // Car details
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    // Error for invalid array index
    error BadCarIndex(uint256 index);

    // Add a car to caller's garage
    function addCar(
        string memory _make,
        string memory _model,
        string memory _color,
        uint _numberOfDoors
    ) external {
        garages[msg.sender].push(Car(_make, _model, _color, _numberOfDoors));
    }

    // Get all cars in caller's garage
    function getMyCars() external view returns (Car[] memory) {
        return garages[msg.sender];
    }

    // Get all cars in a specific user's garage
    function getUserCars(address _user) external view returns (Car[] memory) {
        return garages[_user];
    }

    // Update details of a car in caller's garage
    function updateCar(
        uint256 _index,
        string memory _make,
        string memory _model,
        string memory _color,
        uint _numberOfDoors
    ) external {
        if (_index >= garages[msg.sender].length) {
            revert BadCarIndex(_index);
        }
        garages[msg.sender][_index] = Car(_make, _model, _color, _numberOfDoors);
    }

    // Remove all cars from caller's garage
    function resetMyGarage() external {
        delete garages[msg.sender];
    }
}
