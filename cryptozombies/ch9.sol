
//! Chapter 9: Private / Public Functions

// Solidity functions are public by default. 
    // Anyone (or any contract) can call our contract's function and execute its code

// Not always ideal. Makes contract vulnerable to attacks
    // Good practice to mark functions as private by default, then make public the functions you want to expose to the world

// Declare private function:

uint[] numbers;

function _addToArray(uint _number) private {
    numbers.push(_number);
}

// Only other functions within our contract will be able to call this function and add to the numbers array

// Include visibility keyword after the function name. Start private function names with an underscore!

//* Test

// createZombie function is public by default. Make private

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
    function _createZombie(string memory _name, uint _dna) private {
        zombies.push(Zombie(_name, _dna));
    }

}