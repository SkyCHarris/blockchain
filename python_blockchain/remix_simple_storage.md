
# Remix Simple Storage

#### Solidity Plug-in

## Create Application that can Store Info on the Blockchain

#### Deploy & Run Transactions Tab
- Compiles solidity code down to machine code
- Many diff. parameters to choose
    - compiler version
    - language
    - evm version

### Use JavaScript Virtual Machine to deploy (Changed to Remix VM (London))
- Simulates deploying to testnet/mainnet

#### Test locally
- Will make code experience faster

### Define Solidity Version

pragma solidity >= (version)

- Ctrl + S to save and compile

pragma solidity >= 0.6.0 <0.9.0;

Solidity constantly updated. Learn how to switch between versions seamlessly

### Define contract
- Stands for smart contract
    - Like a class

pragma solidity >= 0.6.0;

contract SimpleStorage {

}

## Types and Declaring Variables

- uint: unsigned integer, not pos. or neg.
- int: normal

#### Define variable:

uint256 favoriteNumber = 5;

- uint256 means its an integer of 256 bits
    - can just do:

unit favoriteNumber = 5;

#### bool:

bool favoriteBool = False;

#### str:

string favoriteString = "String"

#### int: 

int256 favoriteInt = -5

#### address (ETH address):

address favoriteAddress = 0x9c1B089A7307B118d65F9844388CAB3ed8e90Fd9;

#### bytes:

bytes32 favoriteByts = "cat"

- 32 bytes in this variable favoriteBytes

## Just Store Numbers
### Default Initializations

pragma solidity >= 0.6.0;

contract SimpleStorage {

    uint256 favoriteNumber = 5;

}

- favoriteNumber gets initialized even w/out assignment
- if blank, initialized to Null value (0)

## Functions
- Self-contained modules that will execute a task for us
``` js
   function store(uint256 _favoriteNumber) public {    // pass type, then parameter, then 'public'
        favoriteNumber = _favoriteNumber;
}
```

## Deploy a Contract

[vm]from: 0x5B3...eddC4to: SimpleStorage.(constructor)value: 0 weidata: 0x608...60033logs: 0hash: 0x7ad...a4733

![Alt text](<../Screenshot 2024-01-25 113009.png>)

### Calling a Public State-Changing Function

![Alt text](image.png)

Any time we want to make a state change on the blockchain, pay some gas. Like this store function


## Visibility

How do we actually see our favoriteNumber from favoriteNumber function?

- Add 'public' to our favoriteNumber
- Delete previous contract
- Re-deploy
- Scroll down
- 2 buttons pop up in 'Deployed Contracts'
    1. favoriteNumber -> initialized to 0
    2. store function

![Alt text](<Screenshot 2024-01-25 113728.png>)

'Public' keyword defines visibility of the variable or the function.

4 types of visibility:
1. external
2. public
3. internal
4. private

Public: can be called by anybody, including variables.
Variables are a function call to look at them, and return whatever variable that is

External: can't be called by the same contract, must be called by external contract.

Internal: can only be called by other functions inside this contract, or its derived contract

Private: only visible for the contract they're defined in, not derived contracts.

#### Default Visibility
- If we don't give state variable visibility, it will auto-set to internal.

#### Updating a Variable

~Hit favoriteNumber variable

[call]from: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4to: SimpleStorage.favoriteNumber()data: 0x471...f7cdf

- Shows the value of favoriteNumber as 0
- Whatever value we pass it will change favoriteNumber to whatever we pass

~ Pass num. to 'store', hit favoriteNumber variable button
- Value is now 123

<i>Note:</i> State-Changing Function Calls are Transactions

We'll be using:
- transactions 
- smart contract interactions 
- function calls interchangeably

State changes to the blockchain are also transactions

### Scope

We can access favoriteNumber inside the function because favoriteNumber has this global, contract scope.

Functions only know about variables in the same scope as them.

### View Functions

``` js
function retrieve() public view returns(uint256) {
        return favoriteNumber
    }
```

~Change favoriteNumber by calling 'store' function, 123

favoriteNumber and retrieve both say '123'

Why is 'store' orange, and favoriteNumber and retrieve blue?

### View and Pure are Non-state-changing Functions

- View/Pure define functions, but don't need to have a transaction made

View: read some state off the blockchain
Public: also 'view' functions

Can click to view and read the state off the blockchain.

<b>Pure functions are functions that do some kind of math</b>

Do math, but don't save state anywhere:

``` js
function retrieve(uint256 favoriteNumber) public pure {
        favoriteNumber + favoriteNumber;
    }
```

Nothing shows up at the bottom because we didn't return anything.

``` js
function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
```

<i>This application, so far, allows person to store favoriteNumber then retrieve it later</i>

What if we want list/group of people and store their favorite numbers, or associate favorite number with a given person?

## Struct
- A way to define new types in solidity
- Like creating new objects

```js
struct People {
    uint256 favoriteNumber;
    string name;
    }
```

Here we have a new type (People) that has favoriteNumber and name inside of it.

```js
People public person = People({favoriteNumber: 7, name: "Sky"})
```

~Click 'person' struct
![Alt text](<../Screenshot 2024-01-25 121224.png>)

- index 0: favoriteNumber
- index 1: name

## Arrays

ARRAY: way to store a list of an object or type
- type -> visibility -> name

```js
People[] public people;
```

Starts as an empty array

DYNAMIC ARRAY: an array that can change size

FIXED ARRAYS: Arrays that can't change size

```js
People[1] public people;
```

#### Compiler Error

- Red: Compile Error. Code will not deploy
- Yellow: Compiler Warning. Helpful tip that something might be "off" or "wrong"

### Create function addPerson to be able to add person to the array

```js
function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People({favoriteNumber: _favoriteNumber, name: _name}));
    }
```

#### Alternative way to create:

```js
function addPerson(string memory _name, uint256 _favoriteNumber) public {
    people.push(People(_favoriteNumber, _name));
    }
```

### Memory (keyword)

Solidity has 2 ways to store information:
1. Memory: data will only be stored during execution of the function or contract call
2. Storage: data persists even after the functino executes

STRINGS are actually not value types, they're an ARRAY of BYTES.

So a variable of type strings is a special type of array we can append text to. Since it's an object, we decide where we want to store it.

When you use a parameter that's going to be a string from one of our functions, need to call it string memory.

Now we have a new function 'addPerson'. Since it's a state change, its an orange button, and we can add a str name.

![Alt text](<../Screenshot 2024-01-25 174607.png>)

Add person -> give index to 'people'? (0) -> person at 0 indes is Sky

Continue adding people (state change addPerson)
- Zara, 5 (now at index 1)

## Mapping

Looking to find precise person? Find Becca? Know her name, but not her fav number? Can we do it without triaging the entire array?

MAPPING: takes some kind of key, spits out whatever variable its mapping to. A dictionary-like data structure.

```js
mapping(string => uint256) public nameToFavoriteNumber;
```

```js
// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.6.0;

contract SimpleStorage {

    // gets initialized to 0
    uint256 favoriteNumber;

    // object
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // array
    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {    // pass type, then parameter, then 'public'
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}
```
1. Map the _name "zara' to _favoriteNumber
2. Hit addPerson, enter "Zara",4
3. Hit nameToFavoriteNumber function (blue)

![Alt text](<../Screenshot 2024-01-25 180222.png>)

### SPDX License Identifier
Standard operating procedure. MIT is open, anyone can use for anything.

## Deployment

How do we actually employ this so other people can use this contract?

[https://docs.chain.link/resources/link-token-contracts]

1. Change environment from JavaScript EVM (Remix VM (London)) to Injected Provider - Metamask
2. Switch to testnet (Goerli) in MetaMask

'Injected MetaMask" means we're taking our MetaMask and injecting it into the source code of the browser.

3. Deploy (orange button)
4. Confirm in MetaMask
5. Get link in terminal to etherscan

![Alt text](<../Screenshot 2024-01-25 181413.png>)

We've made a transaction on the blockchain to create a contract.

## Interacting with Deployed Contracts

#### In Etherscan click on the To: [Contract xxxxxx Created] to interact with the contract!

Orange Buttons: state-change, require ETH
Blue Buttons: non-state-changes

## EVM

All the Solidity was compiled down to EVM, Ethereum Virtual Machine.

Many blockchains are EVM-compatible. All the solidity and functions can compile down to EVM and deploy on the blockchain.

### Recap

- Name Solidity version
- Name Contract (like a class, defines functions and parameters of your contract)
- Types: uint, bool, bytes
- Structs
- Arrays
- Mapping
- Functions
- 'View' functions don't make state change
- Memory/storage 2 diff ways to initialize where a variable will be saved