// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract FavoriteRecords {
    // Approved album list
    mapping(string => bool) private approvedRecords;
    string[] private approvedRecordsIndex;

    // User favorites
    mapping(address => mapping(string => bool)) public userFavorites;
    mapping(address => string[]) private userFavoritesIndex;

    // Error for adding unapproved album
    error NotApproved(string albumName);

    // Set approved albums on deployment
    constructor() {
        approvedRecordsIndex = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];
        for (uint i = 0; i < approvedRecordsIndex.length; i++) {
            approvedRecords[approvedRecordsIndex[i]] = true;
        }
    }

    // Return all approved album names
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordsIndex;
    }

    // Add an approved album to caller's favorites
    function addRecord(string memory _albumName) public {
        if (!approvedRecords[_albumName]) {
            revert NotApproved(_albumName);
        }
        if (!userFavorites[msg.sender][_albumName]) {
            userFavorites[msg.sender][_albumName] = true;
            userFavoritesIndex[msg.sender].push(_albumName);
        }
    }

    // Return a user's favorite albums
    function getUserFavorites(address _address) public view returns (string[] memory) {
        return userFavoritesIndex[_address];
    }

    // Clear caller's favorite list
    function resetUserFavorites() public {
        for (uint i = 0; i < userFavoritesIndex[msg.sender].length; i++) {
            delete userFavorites[msg.sender][userFavoritesIndex[msg.sender][i]];
        }
        delete userFavoritesIndex[msg.sender];
    }
}
