// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

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

    mapping(string => uint256) public nameToFavoriteNumber;

    // function that stores and updates myFavoriteNumber.... Hint: Everytime you updates the state of a blockchain, is going to cost gas.
    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    /**
     * View and Pure
     * View disallows updating state, it only allows to Read from the state.
     *
     * Pure disallows both Updating and Reading from state.
     *
     * Thus calling view and pure doesn't cost gas. They don't send transactions.
     */

    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        Person memory newPerson = Person(_favoriteNumber, _name);
        listOfPeople.push(newPerson);

        listOfPeople.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
