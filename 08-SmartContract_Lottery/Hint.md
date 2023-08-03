# Install dependencies after cloning a repo

forge build

# Get Random number

https://docs.chain.link/vrf/v2/subscription/examples/get-a-random-number

# Installing Chainlink contract

forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit

# Eth Signature Database: How to know the name of the Hash, you are interacting with

https://openchain.xyz/signatures

# Solmate

Solmate is a gas opinionated building block for building smart contracts.
Here we used Solmate to install the mock LinkToken.

forge install transmissions11/solmate --no-commit

# Running the FundSubscription defined in the interactions.s.sol

forge script script/Interactions.s.sol:FundSubscription --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast

# Foundry-Devops... Helps us to get the recently deployed contract

forge install Cyfrin/foundry-devops --no-commit

# To see the lines we have't covered in our test

forge coverage --report debug > coverage.txt

# Forge test debug

forge test debug

forge test debug --mt nameOfTheTestCaseYouWantToDebug
