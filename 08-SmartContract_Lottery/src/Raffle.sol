// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";

/**
 * @title  A sample Raffle Contract
 * @author  Mars Ifeanyi
 * @notice This contract is for creating a sample Raffle
 * @dev Implements Chainlink VRFv2
 */
contract Raffle is VRFConsumerBaseV2, AutomationCompatibleInterface {
    /* CUSTOM ERRORS */
    error Raffle__NotEnoughEthSent();
    error Raffle__TransferFailed();
    error Raffle__RaffleNotOpen();
    error Raffle__UpkeepNotNeeded(
        uint256 currentBalance,
        uint256 numPlayers,
        uint256 raffleState
    );

    /** TYPE DECLARATIONS */
    // Hint: enum is a user defined type
    enum RaffleState {
        OPEN, // 0
        CALCULATING // 1

        // CLOSE // 2

        // Hint: The values defined in enum are zero based indexed
    }

    /** STATE VARIABLES */

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane; // gaslane is the same as keyHash in chainlink vrf
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    // What data structure should we use? How to keep track of all the players?... Ans: We are going to use dynamic array because if we use mapping we can't loop through mapping... mapping it not iterable.
    address payable[] private s_players; // dynamic array
    uint256 private s_lastTimeStamp;
    address private s_recentWinner;
    RaffleState private s_raffleState; // creating a new variable of the enum type

    /**
     * EVENTS
     *
     * You can have upto 3 indexed parameters.
     * Indexed parameters are also known as Topics. indexed parameters are searchable
     *
     * Events makes migration easier
     * Events makes front end "indexing" easier
     */

    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);
    event RequestedRaffleWinner(uint256 indexed requestId);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
    }

    // function that allows user to enter a raffle
    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent!"); Hint: Using require is not gas efficient, thus use custom errors instead of require
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        } // Hint: This is more gas efficient

        // A player can only enter the raffle if the raffle is still open
        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__RaffleNotOpen();
        }

        s_players.push(payable(msg.sender));

        emit EnteredRaffle(msg.sender);
    }

    /**
     * @dev This is the function that the Chainlink Keeper nodes call
     * they look for `upkeepNeeded` to return True.
     * the following should be true for this to return true:
     * 1. The time interval has passed between raffle runs.
     * 2. The lottery is open.
     * 3. The contract has ETH.
     * 4. Implicity, your subscription is funded with LINK.
     */
    function checkUpkeep(
        bytes memory /* checkData */
    ) public view returns (bool upkeepNeeded, bytes memory /* performData  */) {
        // check to see if enough time has passed
        bool timeHasPassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
        bool isOpen = RaffleState.OPEN == s_raffleState;
        bool hasBalance = address(this).balance > 0;
        bool hasPlayers = s_players.length > 0;
        upkeepNeeded = (timeHasPassed && isOpen && hasBalance && hasPlayers);
        return (upkeepNeeded, "0x0");
    }

    // functions that programmatically pick the verified random winner. It makes a request to the chainlink node to give us random number.
    /**
     * 1. Get a random number
     * 2. Use the random number to pick a player
     * 3. Be automatically called
     */

    /**
     * @dev Implements Chainlink automations
     * @notice The pickWinner() will be automatically called using Chainlink. we don't want an individual to be calling this function.
     *
     * https://docs.chain.link/chainlink-automation/introduction
     *
     * https://docs.chain.link/chainlink-automation/job-scheduler
     *
     * Hint: Chainlink automation uses CRON expression.
     * https://crontab.guru/#5_0_*_8_*
     */
    // function pickWinner() public {
    //     s_raffleState = RaffleState.CALCULATING;

    //     uint256 requestId = i_vrfCoordinator.requestRandomWords(
    //         i_gasLane,
    //         i_subscriptionId,
    //         REQUEST_CONFIRMATIONS,
    //         i_callbackGasLimit,
    //         NUM_WORDS
    //     );
    // } // Hint: We changed the naming for pickWinner() to performUpkeep()

    /**
     * @dev Once `checkUpkeep` is returning `true`, this function is called
     * and it kicks off a Chainlink VRF call to get a random winner.
     */
    function performUpkeep(bytes calldata /* performData */) external {
        (bool upkeepNeeded, ) = checkUpkeep("");
        // require(upkeepNeeded, "Upkeep not needed");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(
                address(this).balance,
                s_players.length,
                uint256(s_raffleState)
            );
        }
        s_raffleState = RaffleState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        // Quiz... is this redundant?
        emit RequestedRaffleWinner(requestId);
    }

    // VIP: Always code your smart contract using CEI: Checks, Effects, Interactions.Always have this design pattern in mind when you are setting up your code. Always do checks first because it is more gas efficient as it will revert early if the check fails, then Effects second and Interactions last.

    // function that chainlink node call to give us the random number back.
    function fulfillRandomWords(
        uint256 /*requestId */,
        uint256[] memory randomWords
    ) internal override {
        // Checks

        // Effects (Our own contract)

        /**
         * s_players =10
         *  rng =12
         * 12 % 10 =2 ie 12 mod 10 = 2, thus the player at index 2 is the winner
         */
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;

        // Update the Raffle State: Once we get the winner, set the RaffleState to OPEN
        s_raffleState = RaffleState.OPEN;

        // Reset the players array
        s_players = new address payable[](0);
        // Update the lastTimeStamp
        s_lastTimeStamp = block.timestamp;
        emit PickedWinner(winner);

        // Interactions (Other contracts)... External interactions
        (bool success, ) = winner.call{value: address(this).balance}(""); // transfer all the balance from the ticket sales to this winner
        if (!success) {
            revert Raffle__TransferFailed();
        }
    }

    /** Getter Function */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getRaffleState() external view returns (RaffleState) {
        return s_raffleState;
    }

    function getPlayer(uint256 indexOfPlayer) external view returns (address) {
        return s_players[indexOfPlayer];
    }

    function getRecentWinner() external view returns (address) {
        return s_recentWinner;
    }

    function getLengthOfPlayers() external view returns (uint256) {
        return s_players.length;
    }

    function getLastTimeStamp() external view returns (uint256) {
        return s_lastTimeStamp;
    }
}
