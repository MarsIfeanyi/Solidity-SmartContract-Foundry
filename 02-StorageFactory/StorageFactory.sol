// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

// import {SimpleStorage, SimpleStorage2} from "./SimpleStorage.sol";
import {SimpleStorage} from "./SimpleStorage.sol"; // Using named import.

// Hint: The StorageFactory contract is like a manager for all the other contracts.

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts; // dynamic array

    // SimpleStorage public simpleStorage;
    // Hint: The structure is:  type, visibility , variableName... SimpleStorage is of a contract type

    function createSimpleStorageContract() public {
        // How does the storage factory know what simple storage looks like?

        SimpleStorage simpleStorageContractVariable = new SimpleStorage(); // Hint: The "new()" keyword is how solidity knows to deploy another contract ie you are calling another contract to be deployed in this particular contract... ie when you call this function, then the SimpleStorage contract will be deployed.
        // SimpleStorage simpleStorage = new SimpleStorage();

        // Updating the array
        listOfSimpleStorageContracts.push(simpleStorageContractVariable);
    }

    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {
        // Address
        // ABI
        // SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
        listOfSimpleStorageContracts[_simpleStorageIndex].store(
            _simpleStorageNumber
        );
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        // return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}

/**
 * Hint: The ability of smart contract to interact with each other is known as Composability.
 * Smart contract are composable because they can easily interact with each other.
 *
 *
 * Hint: When working with multiple files it is important to keep the version of solidity in mind ie make sure that all the versions of the various files or contract are the same or in the same range.
 */
