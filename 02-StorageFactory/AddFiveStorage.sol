// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {SimpleStorage} from "./SimpleStorage.sol";

// Contract Inheritance
contract AddFiveStorage is SimpleStorage {
    //Hint: overriding the  "store" function defined in the SimpleStorage Contract... myFavoriteNumber is a state variable defined in the SimpleStorage contract.
    function store(uint256 _favoriteNumber) public override {
        myFavoriteNumber = _favoriteNumber + 5;
    }
}
