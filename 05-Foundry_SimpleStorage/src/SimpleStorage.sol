// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract SimpleStorage {
    // Storage/State Varaible... Stored on the blockchain
    uint256 myFavoriteNumber;

    // Struct... Custom type (User defined type)
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person public mars = Person({favoriteNumber: 20145, name: "Mars"});

    // uint256[] public anArray;
    Person[] public listOfPeople; // dynamic array

    // Maps someones name to FavoriteNumber
    mapping(string => uint256) public nameToFavoriteNumber;

    // function that stores and updates myFavoriteNumber.... Hint: Everytime you update/change the state of a blockchain, is going to cost gas ie it is a Write function.
    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    // function that allows user to retrieve myFavoriteNumber ie Reading (view) from the state.
    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // Adding _favoriteNumber and _name to the array
        listOfPeople.push(Person(_favoriteNumber, _name));

        // Updating the mapping
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
