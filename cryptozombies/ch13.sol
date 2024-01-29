
//! Chapter 13: Events

// Conract almost finished...let's add an event!

// Events: a way for a contract to communicate that something happened on the blockchain to an app front-end
    // Can be listening for certain events and take action when they happen

// Example:

// declare the event
event IntegersAdded(uint x, uint y, uint result);

function add(uint _x, uint _y) public returns (uint) {
    uint result = _x + _y;
    // fire an event ot let the app know the function was called:
    emit IntegersAdded(_x, _y, result) {
        return result;
    }
}

// app front-end then listens for the event, like this JavaScript implementation:

YourContract.IntegersAdded(function(error, result) {
    // do something with result
})

//* Test

// We want an event to let our front-end know every time a new zombie was created, so the app can display it:

// 1. Declare an event called NewZombie. Should pass zombieID (uint), name (str), and dna (uint)
// 2. Modify _createZombie function to fire the NewZombie event after adding the new Zombie to zombies array
// 3. Going to need zombie's id.array.push() returns a uint of the new length of the array
    // Since the first item in an array has index 0, array.push() - 1 will be the index of the zombie we just added
    // Store the result of zombies.push() - 1 in a uint called id, so you can use this in the NewZombie event in the next line

pragma solidity >=0.5.0 <0.6.0;

contract ZombieFactory {

    // declare our event here
    event NewZombie(uint zombieId, string name, uint dna);


    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) -1;
        // and fire it here
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}