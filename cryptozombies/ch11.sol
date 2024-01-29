
//! Chapter 11: Keccak256 and Typecasting

// We want _generateRandomDna function to return a semi-random uint. How?

// Eth has hash function keccak256 built in, a version of SHA3. 
// Hash function maps an input into a random 256-bit hexadecimal number.
// A slight change in the input will case a large change in the hash

// Useful for many purposes in Ethereum

// IMPORTANT: keccak256 expects a single parameter of type bytes. 
    // So we have to "pack" any parameters before calling keccak256

//6e91ec6b618bb462a4a6ee5aa2cb0e9cf30f7a052bb467b0ba58b8748c00d2e5
keccak256(abi.encodePacked("aaaab"));
//b1f078126895a1424524de5321b339ab00408010b7cf0e6ed451514981e58aa9
keccak256(abi.encodePacked("aaaac"));

// Return values very different despite small change in input

// Note: Secure random number generation in blockchain is a difficult problem.
    // Our method here is insecure, but good enough for our purposes

//* Typecasting

// Sometimes need to convert between data types:

uint8 a = 5;
uint b = 6;
uint8 c = a * b
// Throws error. Need to typecast b as a uint8 to work
uint8 c = a * uint8(b);

// a *  b returns a uint, but we are trying to store it as a uint8. Typecast it as a uint8 instead.


//* Test

// Fill in the body of _generateRandomDna function

// 1. First line takes keccak256 hash of abi.encodepacked(_str) to generate pseudo-random hexadecimal.
    // Typecast it as a uint
    // Store result in a uint called rand
// 2. DNA should be only 16 digits long. Second line of code should return the above value modulus % dnaModulus

pragma solidity ^0.8.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

}