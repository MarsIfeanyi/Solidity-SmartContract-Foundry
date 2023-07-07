/**
 * Learn how to write solidity scripting here:
 * https://book.getfoundry.sh/tutorials/solidity-scripting
 */

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    // hint: run() is the main function
    function run() external returns (SimpleStorage) {
        // Hint: any transaction we want to send must be put in between the startBroadcast() and stopBroadcast()...
        vm.startBroadcast();

        SimpleStorage simpleStorage = new SimpleStorage();

        vm.stopBroadcast();

        return simpleStorage;
    }
}
