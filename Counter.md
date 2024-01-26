
# Smart Contracat

Capitalize file name in Solidity.

```js
pragma solidity ^0.8.0;
```
Any version greater than 0.8.0 ^

Req.:
1. Be a simple contract that illustrates how smart contracts work
2. Create variables, basic data structures, basic functions
3. Create a smart contract counter
    - Stores numerical value
    - Increase count
    - Decrease count
    - Store a name / set name

CRUD: Create, read, update, delete

Smart Contracts have both the business logic, and the CRUD logic. Data and programs.
-   Like a little microservice by itself

### Save a Count on a Blockchain

Statically typed: need to give type before declaring variable

uint: must be positive integer

#### State Variable Declared:

```js
contract Counter {
    uint count;
}
```
This variable value will get stored directly on the blockchain.

#### Initialize Variable:

```js
contract Counter {
    uint count = 1;
}
```

Add visibility:

```js
contract Counter {
    uint public count = 1;
}
```

Compile -> Deploy -> click 'count' -> value = 1
![Alt text](<images/Screenshot 2024-01-25 190529.png>)

That's a smart contract!

### Other Variable Types

#### String

```js
contract Counter {
    string public name = "My Name";
    uint public count = 1;
}
```
![Alt text](<images/Screenshot 2024-01-25 190955.png>)

### Constructor Function with Smart Contracts

Let's you initialize smart contract with certain values.

Initialize name, count values.

Constructor() runs once and only once, whenever we put the smart contract on the blockchain.

```js
constructor() {
        name = "My Counter";
        count = 1;
    }
```

### Arguments Inside Constructor

Pass on arguments during deployment.

```js
constructor(string memory _name, uint _initialCount) {
    name = _name;
    count = _initialCount;
}
```

Let's us pass in parameters whenever we deploy the contract to the blockchain.

Go to compile tab -> click Compile -> go to deploy tab -> Deploy function (orange) -> click dropdown -> enter parameters -> click transact -> Deployed Contracts -> click count/name

Deploy function has already populated the constructor arguments

- Use underscores _ for function arguments (convention kinda). Avoids having conflicts between state variables and naming variables

Variable scope: state variables read anywhere inside the smart contract, local variables only accessed within functino itself

## Increment Function

Function to increment the count.

Functions:
1. Function keyword
2. Function name
3. Parenthese
4. Curly braces

```js
function increment() public {
        count = count + 1;
    }
```

- Read count from state variable
- Adding 1
- Updating count value

Visibility: set function visibility so that we know we can call it outside the function or not

Compile -> Deploy dropdown -> _NAME = "My Count" / _INITIALCOUNT = 1 -> transact -> Deployed Contracts -> count -> increment - count -> increment -> etc.

That's our first function!

## Increment Operator Shortcut

```js
function increment() public {
        count ++;
    }
```

Takes value, increments by 1. Don't need to reassign count variable.

### Add Return Value

1. Specify in function (header?)
2. Put inside function body

```js
function increment() public returns (uint newCount){
        count ++;
        return count;
    }
```

### Nav Bar on Left (Breakdown)

- ENVIRONMENT: blockchain we're connected to
- ACCOUNT: account we're connected to
    - ETH value is going down. Putting smart contracts on the network creates tx. Anytime you create tx you pay gas fee. Reads are free, writes cost gas

## Decrement Function

```js
function Decrement() public returns (uint newCount) {
        count --;
        return count;
    }
```
![Alt text](<images/Screenshot 2024-01-25 205747.png>)

<i>NOTE: can't make count go below 0, because uint (unsigned integer) must be a postive value</i>


## Get Count Function

Previous functions are explicit functions that write to the blockchain. Let's make some functions that explicitly read from the blockchain.

VIEW: function that reads info from blockchain, doesn't modify state, no gas fee

```js
function getCount() public view returns (uint) {
        return count;
    }

```

## Get Name Function

Returns name

```js
function getName() public view returns (string memory currentName) {
        return name;
    }
```

Provides examples of multiple strategies to accomplish the same thing.

Reader functions return some information.

Don't always want to just read simple state variable value. Will want to do more complex things.

##### Next -> Create function that updates state, accepts arbitrary arguments

## Accept Name Function

Sets name. Writes new information to blockchain, accepts argument that's not a constructor function.

Pass in new name as function argument.

1. Click name = My Contract
2. (alt) Click getName = My Contract
    - Same behavior, just mult. strategies
3. setName = "Foobar"
4. Click name = "Foobar"

## Recap

- Create basic smart contract with Solidity
- Put it on the blockchain
- Use state variables
- Create functions
- Create constructor function
- Read/write functions
- Functions with/without arguments
- Public, private, view visibility
- Done in browser Remix

Next -> take this example, move out of browser into development environment, write tests for smart contracts