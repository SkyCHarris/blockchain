
//! Chapter 10: More on Functions

// Return values, and function modifiers

//* Return Values:

// To return a value from a function, declaration looks like:

string greeting = "What's up dog";

function sayHello() public returns (string memory) {
    return greeting;
}

// In Solidity, function declaration contains the type of the return value (here, a string)

//* Function Modifiers

// The above function doesn't change state in Solidity - e.g. it doesn't change any values or write anything
    // So we could declare it as a view function. 

// View: only viewing data, not modifying it

function sayHello() public view returns (string memory) {}

// Pure: Not even accessing any data in the app:

function _multiply(uint a, uintb) private pure returns (uint) {
    return a * b;
}

// This function doesn't even read from the state of the app - its return value depends only on its function parameters

// Note: Hard to remember when to mark functions as pure/view. Luckily, Solidity compiler is good about issuing warnings to let you know

//* Test:

// We'll want a helper function that generates a random DNA number from a string

// 1. Create a private function called _generateRandomDna.
    // Takes one parameter named _str (string) and returns a uint.
    // Set dtat location of _str parameter to memory
// 2. Function will view some of our contract's variables but not modify them. Mark as view
// 3. Function body should be empty- fill in later

pragma solidity >=0.5.0 <0.6.0;

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

    // start here
    function _generateRandomDna(string memory _str) private view returns (uint) {

    }

}
