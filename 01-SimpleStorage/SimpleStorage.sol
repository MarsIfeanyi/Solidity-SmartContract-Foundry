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

    // Maps someones name to FavoriteNumber
    mapping(string => uint256) public nameToFavoriteNumber; // Mapping is like a dictionary, it has key-value pair and with each key you can get access to a specific value... Hint: Always give your variables descriptives names, just as we have here "nameToFavoriteNumber"

    // function that takes input from the user and then stores and updates myFavoriteNumber.... Hint: Everytime you updates the state of a blockchain, is going to cost gas.
    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
    }

    /**
     * VIEW AND PURE
     *
     * View disallows updating state, it only allows to Read from the state.
     *
     * Pure disallows both Updating and Reading from state.
     *
     * Hint: Thus calling view and pure doesn't cost gas. They don't send transactions.
     */

    // function that allows user to retrieve myFavoriteNumber ie Reading (view) from the state.
    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    /**
     * Hint: When you pass variables as calldata, you cannot modify it but when you pass it as memory then you can modify it.
     */

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // Person memory newPerson = Person(_favoriteNumber, _name);
        // listOfPeople.push(newPerson);

        // Adding _favoriteNumber and _name to the array
        listOfPeople.push(Person(_favoriteNumber, _name));

        // Updating the mapping
        nameToFavoriteNumber[_name] = _favoriteNumber; // Anytime you look at someone's name in the mapping you will automatically get access to their favorite number ie nameToFavoriteNumber[key] = value... ie You can quickly access peoples favoriteNumber just by knowing their names.
    }

    /**
     * Evm can access and store inforamtion in six places in solidity.
     *
     * 1: Stack
     * 2: Memory
     * 3: Storage
     * 4: Calldata
     * 5: Code
     * 6: Logs
     *
     * Calldata is temporary variables that can't be modified.
     * Memory is temporary variables that can be modified.
     * Storage is permanent variables that can be modified.
     *
     * Hint: String is an array of bytes
     *
     */
}
