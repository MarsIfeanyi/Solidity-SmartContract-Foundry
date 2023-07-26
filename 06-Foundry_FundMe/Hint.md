### Testing contract

forge test

# Installing Chainlink contract

- forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit

# 4 Different Types of test

1. Unit
   - Testing a specific part of our code
2. Integration
   - Testing how our code works with other parts of our code
3. Forked
   - Testing our code on a simulated real environment
4. Staging
   - Testing our code in a real environment that is not production

# Forked Testing

forge test -m testPriceFeedVersionIsAccurate -vvv --forked-url $SEPOLIA_RPC_URL

# To see how much of our code is tested

forge coverage --fork-url $SEPOLIA_RPC_URL

# Testing

forge test --fork-url $SEPOLIA_RPC_URL

# ChainList

https://chainlist.org/
