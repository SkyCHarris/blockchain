
//! Chapter 7: Function Declarations

// Function declaration in solidity looks like:
contract ZombieFactory {

    function eatHamburgers(string memory _name, uint _amount) public {

    }
}

// This function named eatHamburgers takes 2 parameters: string & uint
// The body of the functino is empty for now
// Note we're specifying the function visibility as public
    // We're also giving instructions about where _name variable should be stored -> in memory
        // This is required for all reference types such as arrays, structs, mappings, strings

// What is a referency type?
// Two ways to pass an argument to a Solidity function:
    // 1. By Value: solidity compiler creates a new copy of the parameter's value and passes it to your function
        // Allows function to modify the value without worrying that the value of the initial parameter gets changed
    // 2. By Reference: function is called with a reference to the original value
        // If funciton changes the value of the variable it receives, the value of the original variable gets changed

// Note: Convention is to start functin parameter variable names with an underscore _ to differentiate from global variables

// Call function:

eatHamburgers("vitalik", 100);

//* Test

// In our app we need to be able to create some zombies. Create a function for that:

// 1. Create public function named createZombie. Take 2 parameters: _name (str) and _dna (uint).
    // Don't forget to pass the first argumnet by value using memory keyword

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
        
    }

}

