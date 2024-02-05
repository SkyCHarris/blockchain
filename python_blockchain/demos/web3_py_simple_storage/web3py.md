
# Web3.py

We've been working with Remix so far. Powerful Web IDE. Friendly, easy to see, create, test.

Limitations:
- Hard to integrate other projects
- Limited support for test or deployments
- Can't save files locally
- Needs internet
- No Python

Deploy, test, and automate everything about smart contract development cycle by connecting with Python.

### Web3.py
- Powerful Python package for doing everything we want with smart contracts

### Brownie

Smart Contract development framework built on web3.py

### Extensions/Downloads

1. Python VSC
2. Solidity VSC (Juan Blanco)
3. Python Download

### Files/Folders

1. mkdir demos
2. mkdir web3_py_simple_storage
3. Make file SimpleStorage.sol
4. Paste from Remix

## Deploy in Python

### Reading our Solidity File

Get SimpleStorage.sol into python script so it knows what to deploy

### Running a Python Script in Terminal

#### Compiler

Install
- pip install py-solc-x

Import
- from solcx import compile_standard

```py
from solcx import compile_standard, install_solc
install_solc("0.6.0")


# Open, read from simplestorage. Place in variable
with open("SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()


# Compile Our Solidity
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.6.0",
)
print(compiled_sol)
```

Output is a lot of low-level code, a massive object.

#### Application Binary Interface

Paste ABI from compiled SimpleStorage.sol in Remix. Gives you a JSON file.

Lowest digestible way to say, hey:
- Here's where all the functions are
- Here's the parameter types
- Return types
- etc.

```json
        "name": "addPerson",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
```

### Output and Print to File

```py
with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)
```

### Formatting JSON

<b>right-click -> Format Document</b>

### Mini-Recap

1. Compiled our Solidity
2. Stored solidity code to compiled_code.json file
3. (Next) Deploy in Python and test out

## Deploy in Python (to a chain)

1. Get Bytecode of file
2. Get ABI of file

#### Bytecode
```py
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]
```

We're walking down the JSON file: "contracts" -> "SimpleStorage" -> "SimpleStorage" -> "evm" -> etc.

#### ABI

```py
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]
```

Now deploy! But where? Which blockchain?

#### Simulate Our Deployment

## Ganache

Simulated, fake blockchain. Deploy to this to act like a real blockchain.

Allows us to spin up our own, local blockchain.

One-click blockchain:
- Not connected to any other blockchain out there
- Acts like blockchain, but faster (even than testnet)

1. Open Ganache
2. Click Quickstart (Ethereum)

## Web3.py

pip install web3

### Connect to Blockchain

#### Choose an http/rpc provider

![Alt text](<images/Screenshot 2024-01-30 205655.png>)

RPC: HTTP://127.0.0.1:7545

Connect directly to simulated, fake blockchain

```py
w3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:7545"))
```

#### ChainId / Network Id

Network ID: 1337

```py
chain_id = 1337
```

#### Address to Deploy From

Grab any from list of addresses in main block of ganache GUI page

```py
my_address = "0x5f58Ffbf26231557A07066b1EAB5ee82cf229c12"
```

#### Private Key

Click key icon on right

Private Key:
- 0x7555257e70e6a577bb6078a131614efe3647b62940caa0eaa18fd977f111c363

### Deploy to Ganache

```py
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
print(SimpleStorage)
```

returns:
```py
 <class 'web3._utils.datatypes.Contract'>
```

### Build a Transaction

1. Build the Contract Deploy Transaction
2. Sign the Transaction
3. Send the Transaction

Nonce: a word coined or used for just one occasion

Account nonces track the number of transactions made. Everytime we make another transaction, it's hashed with a new nonce.

Need it to send our transaction

```py
nonce = w3.eth.get_transaction_count(my_address)
```

#### Need to make a transaction to deploy this contract
- Every time we change state on blockchain is in a tx

Let's create a tx object:

```py
transaction = SimpleStorage.constructor().buildTransaction({})
```

SimpleStorage technically has a constructor. Every contract does. This one's just blank

#### Transaction Parameters

Must give some parameters:
- chainId
- from address
- nonce

```py
transaction = SimpleStorage.constructor().build_transaction(
    {"chainId": chain_id, "from": my_address, "nonce": nonce})
print(transaction)
```
Returns more parameters than we specified:
- value (eth)
- gas
- gas price
- chainId
- from
- nonce
- giant data object (encompasses everything happening in SimpleStorage.sol)
- to (empty)

#### Sign Transaction

Since we're sending it from our address, our private key is only key that will work to sign this.

Signing with private key creates unique Message Signature.
- Only we can create it
- Anyone else can verify it

```py
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
```

#### NOTE: Never hard-code your private key

## Environment Variables

Variables we can set in terminal and command lines.

Environmental Variables set through terminal only up as long as terminal is live.

### Environmental Variables in Python

Not sure I wanna do it through Twilio. Instead:

.env file

```env
export PRIVATE_KEY=0x7555257e70e6a577bb6078a131614efe3647b62940caa0eaa18fd977f111c363
```
#### Add git.ignore! Don't push to github!!

file = .gitignore

.env

#### Load from .env without exporting env variables or anything like that

pip install python-dotenv

load_dotenv()
- place at top of script, below imports

Run script, it'll print out this variable

```py
private_key = os.getenv("PRIVATE_KEY")
print(private_key)
```

We're signing a transaction that is deploying a contract to the blockchain!

### Send to the Blockchain

```py
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
```

This sends our tx to the blockchain.

Look at tx's in Ganache. Empty currently.

1. Run deploy.py
2. Check Ganache

![Alt text](<images/Screenshot 2024-01-30 215835.png>)

![Alt text](<images/Screenshot 2024-01-30 215940.png>)

We sent our first tx to a local blockchain!

### Wait for Block Confirmations

```py
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
```
This will have our code stop and wait for tx hash to go through

## Working with the Contract

When working with contracts and on-chain, we always need 2 things:

1. Contract address
2. Contract ABI

ABI for contract can usually be googled.

We need to make new contract object to work with contracts.

```py
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
```

Address is in the tx_receipt above ^

### Calling a View Function with Web3.py

Do a print() statement to get initial value that's returned from retrieve function.

```py
function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
```
- Initialized to 0

```py
print(simple_storage.functions.retrieve())
```
Returns:
- <Function retrieve() bound to ()>

#### Call vs Transact

When making tx on a blockchain, 2 ways of interacting with them:
1. Call
2. Transact

Call -> Simulate making the call and getting a return value. Don't make a state change. Blue buttons from Remix

Transact -> Make a state change. Build a tx, send a tx. Can always transact on a function, even if it's just a view. Will attempt to make a state change. Orange buttons from Remix.

```py
print(simple_storage.functions.retrieve().call())
```
Returns 0

#### store()
store() function is orange, and will actually make a tx. But we can just use call on it

```py
print(simple_storage.functions.store(15).call())
```

Returns:
- empty list
- that's because store() function has no return type

Update with return value:

```py
function store(uint256 _favoriteNumber) public returns(uint256) {    // pass type, then parameter, then 'public'
        favoriteNumber = _favoriteNumber;
        return _favoriteNumber;
    }
```

Returns:
- 15

![Alt text](<images/Screenshot 2024-01-31 112118.png>)

Lots of transactions in our Ganache, but none are contract interactions. When we call a function we just simulate working with it.

If we were to call retrieve() right after, we'd get 0. Calling is just a simulation.

### Build a New TX to Store Some Value in this Contract

Since we want to make a tx, go through same process as when we deployed this contract.

```py
store_transaction = simple_storage.functions.store(15).build_transaction(
    {"chainID": chain_id, "from": my_address, "nonce": nonce + 1}
)
```

nonce + 1 here because nonce can only be used once per tx.

Now that we have tx, let's sign it:

```py
signed_store_tx = w3.eth.account.sign_transaction(store_transaction, private_key=private_key)

```

Now that we've signed tx, let's send it:

```py
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)
```
REMEMBER:

1. Build tx
2. Sign tx
3. Send tx

Run program.

In Ganache, instead of a bunch of contract creations, we have a contract call!

![Alt text](<images/Screenshot 2024-01-31 114123.png>)

We've updated and sent the tx to a blockchain.

Call retrieve funciton again and we'll print out newly updated value (15).

We made our first state change to a contract we've deployed on our local blockchain!

### Added Syntax for Clairty.

```py
print("Deploying contract...")
print("Contract deployed.")
print("Updating contract...")
print("Contract updated.")
```

```py
from solcx import compile_standard, install_solc
import json
from  web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

install_solc("0.6.0")

# Open, read from simplestorage. Place in variable
with open("SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()


# Compile Our Solidity
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)   # Takes compiled_sol json variable and dump it into file

# Get bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

# Get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# Connect to ganache
w3 = Web3(Web3.HTTPProvider("HTTP://127.0.0.1:7545"))
chain_id = 1337
my_address = "0x5f58Ffbf26231557A07066b1EAB5ee82cf229c12"
private_key = os.getenv("PRIVATE_KEY")

# Create contract in Python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# Get latest transaction
nonce = w3.eth.get_transaction_count(my_address)

# Build a transaction object
transaction = SimpleStorage.constructor().build_transaction(
    {"chainId": chain_id, "from": my_address, "nonce": nonce})

print("Deploying contract...")
# sign transaction
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

# Send signed transaction
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Contract deployed.")

# Working with Contract (address, abi)
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

# Initial value of favoriteNumber
print(simple_storage.functions.retrieve().call())

print("Updating contract...")
store_transaction = simple_storage.functions.store(15).build_transaction(
    {"chainId": chain_id, "from": my_address, "nonce": nonce + 1}
)
print("Contract updated.")

# Sign tx
signed_store_txn = w3.eth.account.sign_transaction(store_transaction, private_key=private_key)

# Send tx
send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)

# ABOVE
# 1. Build tx
# 2. Sign tx
# 3. Send tx

print(simple_storage.functions.retrieve().call())
```

## Ganache CLI

1. install npm
2. install yarn
    - Package manager similar to pip for Python
3. install galache cli
    - yarn global add ganache-cli
    - UPDATED: npm install -g ganache

Run ganache-cli:
- ganache-cli
- runs directly in terminal

Results:

Available Accounts
==================
(0) 0xB61F0ef846D58fDC3AcD4F9C56384bD3D9F7BDe6 (1000 ETH)
(1) 0x13Be28C77004B756852372e92A7Cd29142953212 (1000 ETH)
(2) 0xB4Df7005a773ffB7c0e7D20A0aBAF3417600E788 (1000 ETH)
(3) 0xd473C12D3B5AA3E603f60cDB1Da47a6358D9be2A (1000 ETH)
(4) 0x18Ae055Dd02492D17490bE2bD2CCc54fC5B12613 (1000 ETH)
(5) 0x2e0786FC5c6635a9C8179b0D3466fd0103dF153a (1000 ETH)
(6) 0x62BdC4e0B5dc12906EA0e7b5939304D7f4e405C7 (1000 ETH)
(7) 0xe4EAfeeF0C49eEd75233ed869418F9bd6dB0f1b5 (1000 ETH)
(8) 0x8535C3fc30b86baeA2a2BeAF48e1fd72f121f6DB (1000 ETH)
(9) 0xF1DF4b87252b0235c053686ae89aE3258F3e30d2 (1000 ETH)

Private Keys
==================
(0) 0xa9a09b4c2e6efdf8684353e6ea56f7c30b8cc2d09521c873551e6e65530b6a46
(1) 0x077bf8c874c3f4d5c30f6e4a0731426f9b69367d31fcbd30a2c2a96dc8366e35
(2) 0xe9f17c2fdd459bcc2cf0daf7e0e06ad767babd2c174d55337ebf4e4f31735664
(3) 0xb19874d70743d605cc51d45f2a63189c1929afa5a50d4a051f968f0e2ebcbca0
(4) 0xb11d8dbe6c773fc3a499f491d4fe4156e54579f8d7e6766ff24d0095e4b1a618
(5) 0xc6b4e7829c478dd8908e1d9dec385c52ac44c9eb5f7a461dd44e7e36aede269d
(6) 0xa801413679e48cb8dc74ed12fc3b106d20aea3ad26bf4a96a55ba71d0c755e8e
(7) 0x1135f0cb264fd308cd2e8f23b7964d1de5ec3c5c406386bf1e6363c4df47c0a7
(8) 0x15dd35e4965f96ac40c6ea032793cc6386ae15a771c506c8582564749e3c82ea
(9) 0xe7164a69fa0eb8986fee7a1c67d582c131795447627ffd56bb5013d6d0920272

### Deterministic

ganache-cli --deterministic

Gives exact same private keys and addresses (instead of random)

Loopback Address / LocalHost
- localhost = RPC Listening on 127.0.0.1:8545

### Work with Ganache in CLI

1. Update Private Keys
2. Update Addresses
3. Update HTTPProvider / RPC URL

Open 2 terminals:

1. Terminal 1: Run ganache-cli --deterministic
    - Copy address and private key to solidity file
2. Terminal 2: Run python application (deploy.py)

Terminal one then contains:

#### Calls made to blockchain:
```json
eth_getTransactionReceipt
eth_chainId
eth_call
eth_chainId
eth_estimateGas
eth_maxPriorityFeePerGas
eth_getBlockByNumber
eth_maxPriorityFeePerGas
eth_sendRawTransaction
```

#### Transaction Information:

```json
Transaction: 0x00485ff0533a91e59ae58d99b3780e1414018751fd59c7a6fe3e1d2c8f635886
  Gas usage: 43618
  Block number: 2
  Block time: Mon Feb 05 2024 12:22:24 GMT-0700 (Mountain Standard Time)
```

## Deploy to Testnet/Mainnet

MetaMask not available natively. So we need a way to connect to a blockchain.

We used an RPC URL that connects to our blockchain. To deploy to testnet/mainnet we can swap that rpc.

We can also run our own blockchain node.

Use an external, third-party client that runs it for us.

### Alchemy

Gives blockchain url to connect with and run what you need to run.

1. Create new project
    - Sepolia testnet
2. Swap w3 (Web3.HTTPProvider)
3. Change ChainID
    - Google
4. Change Address
    - MetaMask Sepolia
5. Change Private Key
    - MetaMask Sepolia

```py
w3 = Web3(Web3.HTTPProvider("https://eth-sepolia.g.alchemy.com/v2/An1bl66-xqC_dOPd4OoxQ9YE18sp05T9"))
chain_id = 11155111
my_address = "0x9c1B089A7307B118d65F9844388CAB3ed8e90Fd9"
private_key = os.getenv("PRIVATE_KEY")
```

Works!

```json
Deploying contract...
Contract deployed.
0
Updating contract...
Contract updated.
15
```

Go to Sepolia Etherscan

![alt text](<images/Screenshot 2024-02-05 125101.png>)

### Recap

- Python
- Deploying to our own local blockchain
- Deploying to testnet/mainnet
- Working with private keys
- Creating tx
- Signing tx
- Sending tx