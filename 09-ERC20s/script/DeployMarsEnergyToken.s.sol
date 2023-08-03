// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {MarsEnergyToken} from "../src/MarsEnergyToken.sol";

contract DeployMarsEnergyToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (MarsEnergyToken) {
        vm.startBroadcast();
        MarsEnergyToken marsEnergyToken = new MarsEnergyToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return marsEnergyToken;
    }
}
