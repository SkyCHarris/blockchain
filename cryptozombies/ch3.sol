
//! Chapter 3: State Variables & Integers

// We've got a shell for our contract. Let's learn about variables

//* State Variables

// State variables are permanently stored in contract storage.
// They're written to the Ethereum blockchain. Like writing to a database

contract Example {
    // This will be stored permanently on the blockchain
    uint myUnsignedInteger = 100;
}

//* Unsigned Integers: uint

// The uint data type is an unsigned integer. It's value must be non-negative.
    // int data type also exists for signed integers

// Note: uint is an alias for uint256, a 256-bit unsinged integer.
    // You can declare units with less bits - uint8, uint 16, uint32
    // Generally want to simply use uint except in specific cases

//* Test

// Our Zombie DNA is going to be determined by a 16-digit number
// Declare a uint named dnaDigits and set it equal to 16