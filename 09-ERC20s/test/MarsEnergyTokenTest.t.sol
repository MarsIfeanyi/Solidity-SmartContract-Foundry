// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {DeployMarsEnergyToken} from "../script/DeployMarsEnergyToken.s.sol";
import {MarsEnergyToken} from "../src/MarsEnergyToken.sol";

contract MarsEnergyTokenTest is Test {
    MarsEnergyToken public marsEnergyToken;
    DeployMarsEnergyToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployMarsEnergyToken();
        marsEnergyToken = deployer.run();

        vm.prank(msg.sender);
        marsEnergyToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, marsEnergyToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        marsEnergyToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        marsEnergyToken.transferFrom(bob, alice, transferAmount);

        assertEq(marsEnergyToken.balanceOf(alice), transferAmount);
        assertEq(
            marsEnergyToken.balanceOf(bob),
            STARTING_BALANCE - transferAmount
        );
    }
}
