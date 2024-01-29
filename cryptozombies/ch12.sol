
//! Chapter 12: Putting it Together

// We're almost done! Let's create a public function that ties everything together.abi

// This public function should take an input, the zombie's name, and uses the name to create a zombie with random DNA

//* Test:

// 1. Create public function createRandomZombie. Takes one parameter (_name)(a string with the data location of memory)
    // Declare as public
// 2. First line runs _generateRandomDna function on _name, and stores it in a uint named randDna
// 3. Second line runs _createZombie function and passes it _name and randDNA
// 4. Solution should be 4 lines of close, including closing bracket } of the function

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

    // start here
    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}