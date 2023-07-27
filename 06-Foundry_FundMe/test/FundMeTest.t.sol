// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    // declaring fundeMe as a state variable. This allows us to use it in various places
    FundMe fundMe;

    /**
     * Hint:makeAddr() comes from foundry, it Creates an address derived from the provided name
     * 
     * function makeAddr(string memory name) internal returns(address addr);

     * */
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    // The first thing when writing test with forge is to setup the test... the setUp() will run first before every other thing.

    function setUp() external {
        // FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run(); // Deploying the contract... Hint: The run() is defined in the DeployFundMe.s.sol script and run returns the deployed FundMe Contract.
        vm.deal(USER, STARTING_BALANCE); //Hint: deal is a foundry CheatCode Sets the balance of an address who to newBalance., ie it sends it some fake money... function deal(address who, uint256 newBalance) external;... https://book.getfoundry.sh/cheatcodes/
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    //Hint: this particular test will fail because msg.sender is not same as the i_owner. You can verify this by log both.
    // function testOwnerIsMsgSender() public {
    //     console.log(fundMe.i_owner()); // This comes from the contract
    //     console.log(msg.sender); // This is who ever calls the contract, thus here is the test function

    //     assertEq(fundMe.i_owner(), msg.sender);
    // }

    // Thus this is the best way to verify that msg.sender is equal to owner
    // function testOwnerIsMsgSender() public {
    //     assertEq(fundMe.i_owner(), address(this));
    // }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        // expectRevert is a cheatcode in foundry.
        vm.expectRevert(); // hey, the next line, should revert
        // assert (This tx fails/reverts)
        fundMe.fund(); // send 0 value
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // This implies that the next Tx will be sent by USER
        fundMe.fund{value: SEND_VALUE}();

        // uint256 amountFunded = fundMe.getAddressToAmountFunded(msg.sender);

        // uint256 amountFunded = fundMe.getAddressToAmountFunded(address(this));

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);

        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    // function testOnlyOwnerCanWithdraw() public {
    //     vm.prank(USER);
    //     fundMe.fund{value: SEND_VALUE}();

    //     vm.prank(USER);
    //     vm.expectRevert();
    //     fundMe.withdraw();
    // }

    // Hint:When we have multiple codes repeating in many places, then we can simply create a modifier which is reusable

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawWithASingleFunder() public funded {
        // Hint: Always use the "Arrange","Act", "Assert" method when you are writing tests.

        // Arrange... Arrange the test ie setup the test
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act... Do the action you actually want to test... Whatever you want to test will be added here.
        //uint256 gasStart = gasleft(); // gasleft()is a function in solidity ... 1000
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner()); // cost:200
        fundMe.withdraw();

        //uint256 gasEnd = gasleft(); // 800
        //uint256 gasUsed = (gasStart - gasEnd) * tx.getprice;
        //console.log(gasUsed);

        // Assert ... Assert the test

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunder = 10; // Hint: If you want to use numbers to generate addresses, then those numbers has to be uint160
        uint160 startingFunderIndex = 1; // Hint: We are starting with 1 because we don't want a zero address.
        for (uint160 i = startingFunderIndex; i < numberOfFunder; i++) {
            // vm.prank new address
            // vm.deal new address
            // fund the fundMe
            // Hint: hoax does both prank and deal combined
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        uint160 numberOfFunder = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunder; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        // Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // Assert
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance ==
                fundMe.getOwner().balance
        );
    }
}
