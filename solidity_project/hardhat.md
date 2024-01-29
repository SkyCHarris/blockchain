# Hardhat

Framework. Set of tools allowing you to create smart contracts, saving time on routine tasks.

- Write tests for smart contracts
- Write scripts for smart contracts
- Deploy to blockchain from your project
- Create client-side applications (w/React)
- Make Hardhat talk to React

Step -> Go from browser-based development to local development

## Setup Hardhat

1. Install node.js
2. Install hardhat
    - npm install --save-dev hardhat
    - npm init (in project folder)
    - npx hardhat
3. Create a JavaScript project
    - Hit enter on everything (make sure you're in project folder)
4. Open in editor (VSCode)

<i>Note: npx is a command that let's us run executables from nodemodules directory. ex. npx run</i>

### Contracts
Lock.sol is a sample smart contract

### Tests
Lock.js is a test, lets you demonstrate behavior of a smart contract and make assertions to verify it works the way you expect

ex. Everything we ran in Remix IDE can be done with JS code in the Lock.js test file

1. Copy Smart Contract Solidity file from Remix IDE
2. Add to 'contracts' folder in VSCode
3. Copy license from Lock.sol test file to new file
4. Delete contracts/Lock.sol
5. Delete test/Lock.js
5. Create new file in test/ -> Counter.js
6. Write tests in Counter.js file
7. Install some dependencies on local computer
    - Copy package.json file from 'https://github.com/dappuniversity/solidity_tutorial/'
8. Copy to our package.json file
9. npm install in cli (installs dependencies in new package.json file)

## Test our Contract

Automated testing

Testing w/ HardHat uses Mocha testing framework and Chai assertion library.
- Very popular in JS
- Come bundled in Hardhat, Truffle, other frameworks

1. import chai
    - const { expect } = require('chai');
    - chai is assertion library, expect is used to write test matchers
2. import Ether's js (library that talks to the blockchain)
    - const { ethers } = require('hardhat');

<i>Note: Test for Smart Contracts usually written in JS. Simulate client-side interactions, use same code as front-end website, other scripts etc.</i>