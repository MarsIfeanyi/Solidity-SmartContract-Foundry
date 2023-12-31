// SPDX-License-Identifier: MIT

/**
 * In this HelperConfig, we want to do two things:
 *
 * 1. Deploy mocks when we are on a local anvil chain
 * 2. Keep track of contract address across different chains
 *
 * Sepolia ETH/USD
 *
 * Mainnet ETH/USD
 */

pragma solidity >=0.7.0 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address priceFeed; // ETH/USD priceFeed address
    }

    // if we are on a local anvil, we deploy to mocks otherwise, grab the existing address from the live network
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8; // Hint: The decimals of ETH/USD is 8
    int256 public constant INITIAL_PRICE = 2000e8;
    uint256 public constant SEPOLIA_CHAINID = 11155111;
    uint8 public constant ETHMAINNET_CHAINID = 1;

    constructor() {
        // block.chainid is a global varaible in solidity... chainid = current chainid.
        if (block.chainid == SEPOLIA_CHAINID) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == ETHMAINNET_CHAINID) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // if the priceFeed is not zero, then that means the mock already has priceFeed deployed, thus return activeNetworkConfig,  else deploy a mockPriceFeed
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // 1. Deploy the mocks
        // 2. Return the mock address

        /**
         * The Constructor of MockV3Aggregator
         *
         * constructor(uint8 _decimals, int256 _initialAnswer) {
         *     decimals = _decimals;
         *     updateAnswer(_initialAnswer); }
         */

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        ); // These are the arguments that constructor needs
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});

        return anvilConfig;
    }
}
