
//! Chapter 5: Structs

// Sometimes you need a more complex data type


//* Structs

struct Person {
    uint age;
    string name;
}

// Struct allows creation of more complicated data types with multiple properties

// Note: strings, new data type, are used for arbitrary-length UTF-8 data

//* Test

// In our app, we want to create some zombies with mult. properties!
// 1. Create a struct named Zombie
// 2. Zombie struct will have 2 properties: name(a string), dna(a uint)

pragma solidity ^0.8.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // start here
    struct Zombie {
        string name;
        uint dna;
    }
}
