
//! Chapter 4: Math Operations

// Math in solidity is straightforward. Follows same operatinos as most programming languages

// Solidity also has exponential operator
    // ex. 5**2 = 25

//* Test

// To make sure Zombie's DNA is only 16 char, make another uint equal to 10^16.
    // This way we can later use the modulus operator % to shorten an integer to 16 digits

pragma solidity ^0.8.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    //start here
    uint dnaModulus = 10**dnaDigits;

}