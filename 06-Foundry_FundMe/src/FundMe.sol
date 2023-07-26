// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner(); // Hint: Nice convention for naming your errors is to add the name of the contract and __, This will help to easily know the contract where the error is coming from. This is a nice convention for error handling

contract FundMe {
    using PriceConverter for uint256;

    // Hint: storage variables should start with s_variableName... VIP private variables are more gas efficient than public variables, thus we want to default all storage variables as private.

    mapping(address => uint256) private s_addressToAmountFunded; // Hint: address is the key, while uint256 is the amount

    // Hint: You can also name your mapping
    //mapping(address userAddress => uint256 amountFunded) public s_addressToAmountFunded;
    address[] private s_funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18; // 5 * 1e18

    AggregatorV3Interface private s_priceFeed;

    //Hint: We want the priceFeed to be dynamic and not hardcoded. Thus we pass the priceFeed as an argument to the constructor function upon deploying the contract.
    constructor(address priceFeed) {
        // Initializing the state/storage variables
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );

        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function withdraw() public onlyOwner {
        for (
            /*Starting index, Ending index, Step amount*/
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex]; // accessing the indexes in the s_funders array
            s_addressToAmountFunded[funder] = 0; // resetting the mapping.ie we reset everything back to zero after withdrawing.
        }

        s_funders = new address[](0); // resetting the array

        // call... Hint: Call forwards all gas or set gas, returns bool
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    /**
     * View / Pure functions (Getters)
     */

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress]; // VIP: Given address(fundingAddress) as the "Key", then get the value(amountFunded)
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
