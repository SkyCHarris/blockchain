
//! Chapter 6: Arrays

// When you want a collection of something, use an array
// Two types:
    // 1. Fixed
    // 2. Dynamic

//* ex.

// Array w/ fixed length of 2 elements:
uint[2] fixedArray;
// Fixed array w/ 5 strings:
string[5] stringArray;
// Dynamic array, no fixed size, can grow:
uint[] dynamicArray;

// Can also create an array of structs:
Person[] people; // dynamic array that can be added to

// Remember- state variables are stored permanently on the blockchain. 
    // So creating a dynamic array of structs is useful for storing structured data in a contract, like a database

//* Public Arrays

// Array can be declared as public. Solidity automatically creates a getter method for it
Person[] public people;

// Other contracts could then read from, but not write to, this array.
    // Useful pattern for storing public data in our contract

// *Test

// Let's store an army of zombies in our app. Show off all our zombies to other apps, so it should be public
// 1. Create public array of Zombie structs, and name it zombies

pragma solidity ^0.8.0

contract ZombieFactory {
    uint dnaDigits = 16;
    uint dnaModules = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }
    
    // start here
    Zombie[] public zombies;

}