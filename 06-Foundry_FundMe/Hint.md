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

forge test --match-test testPriceFeedVersionIsAccurate -vvv --forked-url $SEPOLIA_RPC_URL

OR

forge test --mt testPriceFeedVersionIsAccurate -vvv --forked-url $SEPOLIA_RPC_URL

Hint: The -vvv specifies the visibility of the logging.

# To see how much of our code is tested

forge coverage --fork-url $SEPOLIA_RPC_URL

OR

forge coverage

# Testing

forge test --fork-url $SEPOLIA_RPC_URL

# List of all Chains(ChainList)

https://chainlist.org/

# Bring up Chisel

chisel

# Getting all commands available on Chisel

!help

# To Clear the terminal while on chisel

ctrl+k

# Inspecting the Storage Layout

forge inspect FundMe storageLayout

# Checking the Opcodes

https://www.evm.codes/?fork=shanghai

# Creating a snapshot that shows gas usage

forge snapshot

# Script that help us to grab the most recently deployed contract

forge install Cyfrin/foundry-devops --no-commit

https://github.com/Cyfrin/foundry-devops

# Using cast to verifying that the function metamask is calling in your contract is the actual function

This helps us to be sure that the function that is being called when you are interacting with you contract is the real function and not a different or malicious function.

- cast sig "nameOfTheFunction()"
- cast sig "fund()"

Thus when you run the above command, it generates a HexData, then compare this Hex with the Hex from metamask.
