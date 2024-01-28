
//! Chapter 2: Contracts

// Solidity code is encapsulated in contracts.
// A contract is the fundamental building block of Ethereum apps
    // ALL variables and functions belong to a contract. This will be starting poitn of all our projects

// ex.

contract HelloWorld {

}

//* Version Pragma

// All Solidity source code should start with a "version pragam"
    // Declares version of Solidity compiler this code should use
    // This prevents issues with future compiler versions introducing new changes that would break the code

// We want to compile our smart contracts with any compiler version ranging 0.5.0 (incl.) to 0.6.0 (excl.)
    // ex. pragma solidity >=0.5.0 <0.6.0;

pragma solidity ^0.8.0;

contract HiWorld {

}

//* Test

// To start creating Zombie army, let's create a base contract called ZombieFactory
// 1. In the box, make it so our contract uses correct version
// 2. Create an empty contract called ZombieFactory