
# Fund Me Contract

Contract should be able to accept some type of payment.

```js
contract FundMe {

    function fund() public payable {
        
    }

}
```

A function defined as 'payable' can be used to pay for things.

When calling a function, every function call has an associated value. When making a transaction, you can append a value.
- aka how much wei, gwei, ether, etc. you send with your function call or transaction

WEI: smallest denomination of Ethereum

![Alt text](<../images/Screenshot 2024-01-29 193945.png>)

Button's now red! Red is for payable functions. Now when we hit red fund button, we can add a value associated with it.

What do we want to do with this funding?
- Let's keep track of who sent the funding

### Mapping of Funding

Map addresses and value

```js
mapping(address => uint256) public addressToAmountFunded;
```

Let's keep track of all the people who sent us money, or all the addresses that sent us some value.

#### msg.sender | msg.value
- These are key words in every contract call and tx

- msg.sender -> sender of the function call
- msg.value -> how much they sent

```js
function fund() public payable {
            addressToAmountFunded[msg.sender] += msg.value;
    }
```

Whenever we call fund() now, someone can send value. Everything saved in addressToAmountFunded

1. Deploy
2. New addressToAmountFunded view function available
3. Click dropdown to see full name (address)


### Add Value Alongside Tx

Send 1 gwei

1. Value = 1000000000 Wei
2. Copy account address
3. Put in addresstoAmountFunded
4. Hit fund
5. Hit call
    - We've called the fund() function with value of 1 gwei associated with it

When we send our funds to a contract, that contract (wherever deployed) is now the owner of that amount of Ether.

#### Set Min. Value for People to Fund our Endeavors:

Work in USD, other token, etc. How to convert?

Need to know ETH -> USD conversion rate

## Decentralized Oracle Network

![Alt text](<../images/Screenshot 2024-01-29 195451.png>)

Blockchains can't:
- Agree on random num. (each node randomizes separately)
- Agree on API calls
- Make assumptions about the real world

[Data Feeds / Price Feeds on Chainlink](data.chain.link)

1. Open the contract in Remix
2. Get ETH from Sepolia Faucet
3. Compile, Deploy to Metamask Injected
4. Confirm w/ signature
5. Deployed contracts -> GetChainlinkDataFeedLatestAnswer-call
6. Returns latest price of Ethereum

Why's this number look so big?

<i>Decimals don't work in Solidity. Must return a number that's multiplied by 10^num</i>

## Implement in Any Contract

How to implement data feed into fund me application?

#### Import ChainLink Code

```js
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol"
```

#### What Imports Actually Do

Import takes w/e code you're importing and stick it at the top of your project.

We're actually importing from @chainlink/contracts [NPM package](https://www.npmjs.com/package/@chainlink/contracts)

And the [github](https://github.com/smartcontractkit/chainlink) which tells us more about what's really going on.

[Interface for AggregatorV3Interface](https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol) in Chainlink github.

These contracts start with 'interface' keyword, not 'contract' keyword.

Diff is that interfaces don't have full function implementations. They're not completed. Just have the function name and its return type.

In our code, Solidity doesn't understand natively how to interact with another contract. We have to tell Solidity what functions can be called on another contract.

Interfaces, like structs, can define a new type.

Pasting this interface code above where we declare our contract, we can interact with contracts that have those functions.

```js
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface AggregatorV3Interface {

  function decimals()
    external
    view
    returns (
      uint8
    );

  function description()
    external
    view
    returns (
      string memory
    );

  function version()
    external
    view
    returns (
      uint256
    );

  function getRoundData(
    uint80 _roundId
  )
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

}
```

#### Interfaces compile down to an ABI
- Application Binary Interface

ABI tells solidity and other programming languages how it can interact with another contract, or what functions can be called on another contract.

Anytime you want to interact with an already deployed smart contract, you need that contract's ABI.

### Working with Interfaces

Works the exact same way as working with a struct or variable.

Define new function called get version() and call it on our other contract.

Should be 'public view' since we're just reading a state.

type -> visibility (can skip since inside other contract) -> name -> initialize contract

Initialize contract (how to choose where to interact with contract): AggregatorV3Interface(ETH/USD Chainlink address)

[Sepolia Testnet price feeds](https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#sepolia-testnet)

Sepolia ETH/USD
- 0x694AA1769357215DE4FAC081bf1f309aDC325306

```js
function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }
```

'Contract' has 'these functions in interface' located at 'this address'. Call priceFeed.version() to check if true

```js
function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        priceFeed.version();
    }
```

Deploy to Injected MetaMask environment, because chainlink is located on actual network! With Sepolia network.

![Alt text](<../images/Screenshot 2024-01-29 213539.png>)

Click getVersion
- returns 0: uint256: 4
- aka version 4 

##### We made a contract call, to another contract, from our contract, using an interface!

### Call getPrice function

```js
function getPrice() public view returns (uint256) {
        
    }
```
#### Tuples

```js
function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
```

latestRoundData() function returns 5 variables...hmmm. How to work with that?

```js
function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        priceFeed.latestRoundData();
    }
```

Since this will return 5 diff. values, we can have our contract ALSO return 5 values.

```js
function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
        ) = priceFeed.latestRoundData();
    }
```

Tuple: List of objects of potentially diff. types whose number is a constant at compile-time.

Above is the syntax for getting a tuple. Can define sev. variables inside this tuple.

Add return line and variable. Remember to convert datatype.

```js
function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return uint256(answer);
    }
```

Should return latest price of Ethereum in USD.

![Alt text](<../images/Screenshot 2024-01-29 215345.png>)

We returned the version (getVersion) and price (getPrice)!

Clean up code by 'returning blanks':

```js
function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer);
    }
```

Works great!

### 3rd Way to Import

Import from contracts that are in the same file system as our contract.

### Gwei/Wei/ETH Standard

```js
        return uint256(answer * 10000000000);   // returns price with 18 decimal places (gwei/wei convert)

```
## Set Price of Fund() Function

ex. $50

Convert value sent to us to USD equivalent. See if it's greater than or less than $50.

### getConversionRate

```js
function getConversionRate(uint ethAmount) public view returns (uint) {
        uint256 ethPrice = getPrice();  // calls getPrice() function
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountinUsd;
    }
```

1. Deploy
2. getConversionRate (enter 1 gwei)

![Alt text](<../images/Screenshot 2024-01-30 132604.png>)

Really big number!
- 1 gwei = $2370060715180.000000000000000000 ??

Divide line 31 (ethPrice * ethAmount) / 1,000,000,000,000,000,000

## SafeMath & Integer Overflow

Pitfalls
- If you add to max size uint num. can be, it wraps around to lowest num. it can be
- Integers can wrap-around (reset) if you pass their cap

### Import SafeMath

[OpenZeppelin Contracts](https://www.openzeppelin.com/contracts) tool. Works like a library?

Includes SafeMath

```js
pragma solidity >=0.4.20;   // Not sure why this compiler version but w/e


import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {

    using SafeMathChainlink for uint256;
```

LIBRARY: Similar to contracts, but purpose is that they're deployed once at a specific address and their code is reused

We're attaching SafeMath library to uint256 so that these overflows are checked for.

Using keyword: The directive using A for B; can be used to attach library functions (from library A) to any type (B) in the context of a contract

### SafeMath PSA

We won't be calling functions in SafeMath like div, add, etc. 0.8 forward doesn't require.

### Setting a Threshold

How to guarantee amount user sends when calling fund() will be at least $50?

Set a minimum value.

```js
uint256 minimumUSD = 50;
```

Since everything in gwei terms, want to mult. by 10 ^ 18.

### Require x Amount

#### require() statement

When function call reaches require statement, it checks truthiness of require() ask

```js
require(getConversionRate(msg.value) >= minimumUSD);    
```

Revert tx if doesn't meet threshold. User gets money back, as well as any unspent gas.

```js
require(getConversionRate(msg.value) >= minimumUSD, "Spend more ETH!")
```

#### Test

1. Deploy
2. Click 'fund'
3. Get error:

![Alt text](<../images/Screenshot 2024-01-30 140157.png>)

![Alt text](<../images/Screenshot 2024-01-30 140313.png>)

Try spending more ETH (in Value tab)

## Withdraw Function

Add payable() since we're going to be transferring ETH.

transfer() is a function we can call on any address to send ETH from one address to another.
- Sends some amount of ETH to whoever it's being called on.
- Here that's msg.sender()
- Send all the money that's been funded()

```js
function withdraw() payable public {
        msg.sender.transfer(address(this).balance);
    }
```

#### this
- 'Address of this' -> want the address of the contract you're currently in
- Talking about the contract you're currently in

When you call an address and then the balance attribute, you can see the address of a contract.

In the above line:
- withdraw() -> whoever calls the withdraw function is the msg.sender
- transfer them all of our money

1. Deploy FundMe
2. Value = .3 ETH (300000000 gwei)
3. Click Fund
4. Accept in MetaMask
5. Click Withdraw (get it back)


![Alt text](<../images/Screenshot 2024-01-30 143203.png>)

## Admin-Only (Contract Owner) Permissions

#### require() function
#### function to be called the INSTANT we deploy this contract
- Constructor

```js
constructor() public {
        
    }
```

Whatever we add in here will be immediately executed whenever we deploy this contract

```js
contract FundMe {

    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;  
    address public owner;

    constructor() public {
        owner = msg.sender; 
```

Deploy contract -> click owner (blue function button)

![Alt text](<../images/Screenshot 2024-01-30 144137.png>)

### Use Same require() in Withdraw Function

```js
function withdraw() payable public {
        require(msg.sender == owner);
        msg.sender.transfer(address(this).balance);
    }
```

If we switch accounts, we get an error and cannot withdraw. Must be owner account (contract deployer)

## Modifiers

Use a modifier to write in the definition of our function some parameter that only allows call by admin contract

MODIFIERS: Used to change behavior of functions in a declarative way

```js
modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
```

Ex. "Hey, before you run this function, do this require statement first. Wherever _ is in modifier, run the rest of the code."

```js
modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
    }
```

Before we run withdraw() function, we're going to check onlyOwner modifier. Run require(msg.sender == owner).

## Resetting

When we withdraw from contract, we're not updating balances of people who funded this.

Go through all the funders and reset balances to 0.

Can't loop through keys in a mapping. Each key is initialized at mapping initialization. But we can create another data structure - array.

### Funders[] array

```js
address[] public funders;
```

When someone funds our contract, push them to our funders array.

```js
funders.push(msg.sender)
```

```js
function fund() public payable {
            uint256 minimumUSD = 50 * 10**18;
            require(getConversionRate(msg.value) >= minimumUSD, "Spend more ETH!");    
            addressToAmountFunded[msg.sender] += msg.value;
            funders.push(msg.sender);
    }
```

Now when we withdraw everything, reset everything to 0

### For Loop

```js
function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){

        }
    }

```

- Index variable called funderIndex starts from 0
- Loop finishes when funderIndex is greater than length of funders
- Everytime we finish a loop, add 1 to the funderIndex
- Whenever code in for loop executes, restart at top

```js
function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
```

- grab address of funder from funder's array
- use as key in our mapping
- reset funder array

## Contract Recap

1. constructor() sets us as owner when we deploy
2. fund() allows anyone to fund public good that we're doing
    - Fund with min USD value we set
    - Keep track of how much the fund and who funds it
    - Get price in USD 
3. Get price() of ETH they send in USD terms
4. Convert() to check they're sending us the right amount
5. onlyOwner modifier means only we can withdraw from contract
    - When we withdraw() we reset all the funders who have currently participated in our crowdsourcing application


```js
// SPDX-License-Identifier: MIT

pragma solidity >=0.4.20;   // Not sure why this compiler version but w/e


import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {

    using SafeMathChainlink for uint256;

    // map addresses and values
    mapping(address => uint256) public addressToAmountFunded;   // last part is name of mapping
    address[] public funders;
    address public owner;

    constructor() public {
        owner = msg.sender; // sender is us, whoever deploys this smart contract
    }

    function fund() public payable {
            uint256 minimumUSD = 50 * 10**18;
            require(getConversionRate(msg.value) >= minimumUSD, "Spend more ETH!");    
            addressToAmountFunded[msg.sender] += msg.value;
            funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);   // returns price with 18 decimal places (gwei/wei convert)
    }

    // converts whatever value sent as an eth amount
    function getConversionRate(uint ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();  // calls getPrice() function
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1_000_000_000_000_000_000;
        return ethAmountInUsd;
        // 2370060715180 (18 decimals) = 0.000002370060715180
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }

}
```

![Alt text](<../images/Screenshot 2024-01-30 150419.png>)