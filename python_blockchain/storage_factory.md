# Storage Factory

Get more advanced with what we're gonna do with our smart contracts.

We have our SimpleStorage smart contract. Allows us to:
- Store numbers
- Store fav numbers assoc. w/ diff. people

What if we want lots of SimpleStorage contracts deployed, giving people ability to generate and deploy their own lists based off this contract?

## Storage Factory.sol

* Need to be in same folder to have a contract deploy another contract

#### Create New Contract

```js
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract StorageFactory {
    
}
```

### Imports

Import SimpleStorage contract into StorageFactory Contract.

StorageFactory contract needs to know what SimpleStorage contract looks like.

import -> filepath

```js
import "./SimpleStorage.sol";
```

Equivalent to copy/pasting everything from SimpleStorage contract into StorageFactory file (above)

Can save, compile, and have 2 contracts in the same file.

Deploy: get to choose which contract you want to deploy

![Alt text](<../images/Screenshot 2024-01-27 125713.png>)

This is how we import a contract/file so that our contract knows what the other looks like and can do.

### Deploy a Contract from a Contract

If we want this contract to deploy SimpleStorage contract, need to create a function to do that.

type -> name = new -> contract -> parameters (none here)

```js
contract StorageFactory {
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
    }
}
```

Deploy -> StorageFactory
- Gives us a function that doesn't return anything
- Creating new contracts, but can't read where those contracts are being created

![Alt text](<../images/Screenshot 2024-01-27 130423.png>)

Let's make a way to keep track of all the diff SimpleStorage contracts we deploy.

##### List/Array for Storing Contracts

```js
SimpleStorage[] public simpleStorageArray;
```

SimpleStorage Array[] -> public visibility -> named simpleStorageArray -> initialize
- Every time we deploy we create one of these SimpleStorage contracts, and add it to our array.

Now we have blue button: simpleStorage array.

See what's at index 0, click simpleStorage. Error. Nothing added to it yet.

Click createSimpleStorage contract button (orange).
- Now we've created a tx that will create a new SimpleStorage contract and push it to our simpleStorage array.

![Alt text](<../images/Screenshot 2024-01-27 132007.png>)

Access index 0 of array. We get an address.
- This is the address that the SimpleStorage contract was deployed to!

We've successfully deployed a contract to the blockchain from another contract.

## Interacting with Contract Deployed Contract

We can do more than just deploy the contract. We can deploy a contract from another contract, then call those functions as well.

#### Call Store Function and Retrieve Function from SimpleStorage


We choose _simpleStorageIndex because we're going to choose which simplestorage contract in our list we want to interact with.

Also, pass _simpleStorageNumber to call on the store function that we need to pass a _favoriteNumber to.

#### Interacting with Contract Requires:
1. Address of contract you want to interact with
2. ABI = Application Binary Interface

1. We're going to push and get the address from the SimpleStorage array (line 9)
2. Get ABI from import (line 5)

To interact with SimpleStorage contract:

SimpleStorage -> pass address of contract (get via address & index(simpleStorageArray[_simpleStorageIndex]))
- Returns the contract we want to interact with

```js
function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
        // Address
        // ABI
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
    }
```

Call simpleStorage.store() and add _simpleStorageNumber

```js
simpleStorage.store(_simpleStorageNumber);
```

1. Compile
2. Deploy StorageFactory
3. Several Functions:
- 1 createSimpleStorage: creates the contract and adds it to our array
- 2 sfStore: stores a number to one of those contracts in the array
- 3. simpleStorageArray: lens into the SimpleStorage contract

createSimpleStorage -> sfStore (index, number) -> simpleStorageArray (index) -> can't see number with simpleStorageArray because lacking retrieve() function

Let's add that now ^

sfGet takes _simpleStorageIndex parameter, and chooses one of the contracts on the array and returns its favorite number, calling retrieve() function on that contract.

We're just reading state so it can be a public view function that returns (uint256).

```js
function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        
    }
```

Need to access contract again with SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]))

Then return simpleStorage.retrieve()

```js
function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        return simpleStorage.retrieve();
    }
```
![Alt text](<../images/Screenshot 2024-01-27 135218.png>)

We now have sfGet function.

1. createSimpleStorage contract
2. stStore store function on the zeroth contract (0, 77)
3. sfGet get favorite number of zeroth contract

### Refactor

Don't need to save SimpleStorage contract as variable (line 24)
- Just call retrieve (paste at end)

Same goes for sfStore.

##### Deploy contracts and interact with contracts from another contract!

Need all the functionality of a contract imported to interact with it.

<b>Interfaces</b> will allow us to interact with a contract without having all the functions defined.

## Inheritance

SimpleStorage has some cool functions. Maybe we want them inside our StorageFactory.

We want StorageFactory to be able to create SimpleStorage contracts, AND, be SimpleStorage contract itself.

StorageFactory can INHERIT functions of SimpleStorage w/out having to copypaste them.

<b>contract StorageFactory is of type SimpleStorage</b>

```js
contract StorageFactory is SimpleStorage {

}
```

Just by doing that line in the contract header, StorageFactory contract has all the functions/variables of SimpleStorage.

![Alt text](<../images/Screenshot 2024-01-27 141926.png>)

IS NOW:

![Alt text](<../images/Screenshot 2024-01-27 142001.png>)

## Recap

- Import chunks of code from other files
- Inheritance
- Deploy contracts from our contract
- Interat with diff. contracts from outside of our contract