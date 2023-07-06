
/**
 * PSUEDOCODE:
 * One of the ways to become a great developer is to first of all write down what you want to do before you actually start writing the code. 
 * 
 * Here is what we want to do in this contract.
 *  1. Get funds from users
 *  2. Withdraw funds
 * 3. Set a minimum funding value in USD
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner(); // Hint: Writing Custom errors also helps us to save gas.. VIP: Notice that the custom errors are defined outside the contract. 

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;

// Hint: You can also name your mapping
//mapping(address amount => uint256 amountFunded) public addressToAmountFunded;
    address[] public funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18; // 5 * 1e18
    
    constructor() {
        i_owner = msg.sender;
    }


    function fund() public payable {

/**
 * This function should:
 * Allow users to send $
 * Have a minimum $ sent
 * 
 * 1. How do we send ETH to this contract?... We do this by making the function "payable".
 * 
 * 
 * What is revert?... Reverts undo any actions that have been done before and sends the remaining gas back
 */
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
    
    modifier onlyOwner {
        // require(msg.sender == owner);
        //Hint: Notice how we replaced the require with an if statement and then call the defined custom error. this helps us to save gas
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    
    function withdraw() public onlyOwner {
        for (
            /*Starting index, Ending index, Step amount*/
            uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
// Execute everything insice the loop here for the duration specified above ie  /*Starting index, Ending index, Step amount*/

            address funder = funders[funderIndex];// accessing the indexes in the funders array
            addressToAmountFunded[funder] = 0; // resetting the mapping.ie we reset everything back to zero after withdrawing.
        }

        funders = new address[](0); // resetting the array
        // // transfer
        // payable(msg.sender).transfer(address(this).balance); Hint: transfer has a cap gas of 2300 and throws error
        
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed"); // Hint:send has cap gas of 2300 and returns bool

        // call... Hint: Call forwards all gas or set gas, reurns bool
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

        /**
         * Hint: call allows us to call different function. The call() returns two variables, 1: a boolean that shows success and bytes of the data returned from the function call
         * 
         * here were replace the funtion call as empty string because we are not making any call ie (""), thus if you are making function call, you simply pass in the function inside the call() and then get the returned data as bytes
         * 
         * (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}(theNameOfTheFunctionYouWantToCall);
         */
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()


// Hint: With the fallback() and receive() defined here if someone accidentally send money to this contract without calling the fund(), then it will automatically it to the fund funtion 


// Hint: fallback is called when the calldata is not empty
    fallback() external payable {
        fund();
    }

// Hint: Recieve is only triggered when the calldata is empty... Thus if it is empty and there is a recieve funtion, it will stored in the receive funtion, but if is empty and there is no receieve funtion then it will be stored in the fallback
    receive() external payable {
        fund();
    }

}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly




/**
 *  TRANSACTION FILEDS
 * Every transaction we send on the blockchain will have this values (VIP)
 * 
 * Nonce: tx count for the account
 * Gas Price: price per unit of gas in (in wei)
 * To: Address that the tx is sent to.
 * Value: amount of wei to send.
 * Data: What to send to the  To address.
 * V,r,s: component of tx signature
 * 
 * 
 * BLOCKCHAIN ORACLE: Any device that interacts with the off-chain world to provide external data or computation to smart contracts.
 * 
 * 
 * CHAINLINK DATA FEEDS
 * https://data.chain.link/
 * 
 * https://docs.chain.link/
 * 
 * https://github.com/smartcontractkit/chainlink
 * 
 */