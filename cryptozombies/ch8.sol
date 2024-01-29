
//! Chapter8: Working with Structs and Arrays

//* Creating New Structs

// Learn how to create new Persons for struct Person, and add them to our people array

// create new person
Person satoshi = Person(172, "Satoshi");

// Add that person to the Array:
pepole.push(satoshi)

// Can combine into one line of code:

people.push(Person(16, "Vitali"));

// Note: array.push() adds to the end of the array, so elements are in the order we added them

uint[] numbers;
numbers.push(5);
numbers.push(10);
numbers.push(15);
// numbers is now equal to [5, 10, 15]

//* Test

// Make the createZombie function do something!

// 1. Fill in function body so it creates a new Zombie, and adds it to the zombies array.
    // name and dna for new Zombie should come from function arguments
// 2. Do it in one line of code

pragma solidity ^0.8.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // start here
    function createZombie(string memory _name, uint _dna) public {
        zombies.push(Zombie(_name, _dna));
    }

}