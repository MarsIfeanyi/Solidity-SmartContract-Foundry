// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    //Hint: Note that the run() returns a FundMe Contract, this allows us to easily use and run the FundMe contract in our test file and other places where it is needed.
    function run() external returns (FundMe) {
        // Before startBroadcast -> Not a "real" tx ie anything before the startBroadcast is not going to be send as a real transaction, thus wouldn't cost gas.It will be simulated in a simulation environment

        HelperConfig helperConfig = new HelperConfig(); // Creating a new instance of the HelperConfig and storing it in the helperConfig variable.

        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        // FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        FundMe fundMe = new FundMe(ethUsdPriceFeed); // create a new instance.
        vm.stopBroadcast();

        return fundMe;
    }
}
