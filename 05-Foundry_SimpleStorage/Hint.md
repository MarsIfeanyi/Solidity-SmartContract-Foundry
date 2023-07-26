# Doc:

https://book.getfoundry.sh/

# Installation:

curl -L https://foundry.paradigm.xyz | bash

then read the prompt, follow the instructions and then

- foundryup
  This installs and updates foundry to the latest version.

# Foundry comes with 4 components:

1. forge
2. cast
3. anvil
4. chisel

- forge --version

When you close your terminal and then open it again and run forge --version, you might get an error. to fix it run

source /home/marsifeanyi/.bashrc

OR

- echo "source /home/marsifeanyi/.bashrc" >> .bash_profile

- view .bash_profile

Hint: Each of the above url might vary based on your file path

# compiling the contract

forge build

forge compile

# To run the local node

anvil

# To see all the available commands

forge --help

# To deploy a contract

forge create nameOfYourContract

forge create SimpleStorage

forge create SimpleStorage --interactive

forge create SimpleStorage --rpc-url http:// aashdhd --private-key asjsdhrhrjrjrn

# Running the Deploy script

forge script script/DeploySimpleStorage.s.sol

Hint: in foundry when you did not define rpc url, it will spin up a temporary anvil blockchain node

forge script script/DeploySimpleStorage.s.sol --rpc-url http://127.0.0.1:8545 --broadcast --private-key

# Adding env

source .env, This ensures that all our .env file is loaded.

echo $PRIVATE_KEY

# Deploying the contract using thirdweb

npx thirdweb deploy

Hint: With thirdweb, your contract is automatically verified

# Interacting with the contract from anvil cli

cast --help, gives you all the available commands in cast.

# Deploying to a Testnet

forge script script/DeploySimpleStorage.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast

# Automatically format the solidity codes

forge fmt

Hint: When working with Foundry
Forge is used to deploy contract
Anvil gives us local blockchain nodes
Cast is used to interact with the deployed contract
