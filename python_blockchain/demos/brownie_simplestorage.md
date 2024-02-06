
# Brownie

That was lots of work! Writin own compile code, storage code. 

What if we want to interact with contract we deployed previously?
- We'd need to manually update addresses

What if don't wanna deploy contract every time? Want to work with contract we've already deployed?

What if we want to work with a bunch of different chains?

#### Brownie is the most popular smart contract dev platform built based on Python

Brownie is built on Web3.py


1. Install
    - Via pipx. Installs Brownie into virtual environment, making it available from CLI
    - python3 -m pip install --user pipx
    - python3 -m pipx ensurepath
    - pip install eth-brownie

2. Check working
    - brownie --version (get version)
        - or
    - brownie (get list of commands)

## Simple Storage Brownie Project

Use same simplestorage code, but in Brownie.

1. Begin new Brownie project
    - brownie init
2. Creates new Brownie project with subfolders:
    - build
    - contracts
    - interfaces
    - reports
    - scripts
    - tests

Subfolders Info:

1. Build: 
    - Tracks important, low-level information
    - Tracks interfaces we work with and deploy.
    - Keeps track of deployments across chains
    - Stores compiled code
2. Contracts:
    - Where we put all our contracts
    - Compile, deploy, etc.
3. Interfaces:
    - Save and store different interfaces (aka ChainLink)
4. Reports:
    - Save any time of report we run
5. Scripts:
    - Automate tasks (deploy, call functions, etc.)
6. Test:
    - Does a lot!

### Add 1st Brownie Contract

Create new file in 'contracts\' folder, then paste SimpleStorage.sol file.

Work with Brownie to compile this code WITHOUT having to write or work with our own compiler
- brownie compile

Brownie automatically reads version of solidity, then stores all the compile information in build/contracts folder (json file)

#### Deploy Script to Blockchain

Write a script. Allows us to do w/e we want!

This is where we define working with and deploying our code.

- brownie run command deploys script for us
- brownie run scripts/deploy.py
- link for troubleshoot:
    - https://github.com/jazzband/docopt-ng/issues/49

Defaults to working with local ganache-cli blockchain.

```json
Launching 'ganache-cli.cmd --chain.vmErrorsOnRPCResponse true --server.port 8545 --miner.blockGasLimit 12000000 --wallet.totalAccounts 10 --hardfork istanbul --wallet.mnemonic brownie'...
```

If we don't specify network to use, Brownie spins up local ganache then tears it down.

### Architecture

Put logic of our deployment in its own function def:

```py
def deploy_simple_storage():
    pass

def main():
    deploy_simple_storage
```

To deploy contract, let's look back at Web3.py version.

Brownie Auto:
- Compile (brownie auto)
- Dump to file (brownie auto)
- Get bytecode/abi (brownie auto)
- Add local blockchain (brownie auto)

NEED:
- address
- private key

### Brownie Accounts

Package that natively understands how to work with accounts.

```py
from brownie import accounts
```

3 Ways to Add Accounts:

1. <b>Built-in Local Ganache Accounts</b>
```py
def deploy_simple_storage():
    account = accounts[0]
    print(account)
```
2. <b>Encrypted Command Line</b>
    - Add natively into Brownie
    - brownie accounts new pythonblock-account
    - copy private key -> add 0x -> paste private key
    - enter password to encrypt with
    - brownie accounts list

```json
SUCCESS: A new account '0x9c1B089A7307B118d65F9844388CAB3ed8e90Fd9' has been generated with the id 'pythonblock-account'
PS C:\Users\slakk\OneDrive\Desktop\blockchain\python_blockchain\demos\brownie_simplestorage> 
```
```js
Found 1 account:
 └─pythonblock-account: 0x9c1B089A7307B118d65F9844388CAB3ed8e90Fd9
 ```

 #### Remove Encrypted Accounts
 - brownie accounts delete (account name)

 #### Work with New Account (Brownie CLI)

 ```py
from brownie import accounts


def deploy_simple_storage():
    account = accounts.load("pythonblock-account")
    print(account)

def main():
    deploy_simple_storage()
```

1. brownie run script deploy
2. Enter password

This is a safer way to secure keys. Not going to store in git, won't accidentally push to github or show to anybody, and is encrypted.

3. <b>Environment Variables & Brownie Config</b>

Environment variable script. Won't have to put password in every time you run a script. Only use with test accounts.

1. Make .env file
2. export PRIVATE_KEY=(enter private key here)
3. Tell brownie to pull from .env file in:
    - brownie-config.yaml
    - Special file brownie always looks for to grab info on where we'll build, deploy, and grab things
4. dotenv: .env
    - Says: when you run scripts, grab the env variables from .env file

```py
from brownie import accounts
import os

def deploy_simple_storage():
    account = accounts.add(os.getenv("PRIVATE_KEY"))
    print(account)

def main():
    deploy_simple_storage()
```

Let's make this method even more explicit.

## Brownie Config for Wallets

```yaml
wallets:
  from_key: ${PRIVATE_KEY}
```

```py
from brownie import accounts, config
import os

def deploy_simple_storage():
    account = accounts.add(config["wallets"]["from_key"])
    print(account)

def main():
    deploy_simple_storage()
```

## Import a Contract

Web3.py we opened a contract, then interacted with it.

In Brownie:
```py
from brownie import SimpleStorage
```
Any time you deploy to chain or make a tx:
- 'from' keyword
- who deploys (which account)

```py
from brownie import accounts, config, SimpleStorage
import os

def deploy_simple_storage():
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    simple_storage.wait(1)
    print(simple_storage)

def main():
    deploy_simple_storage()
```

Returns a contract object (so add print() statement to read in terminal)

![alt text](<brownie_simplestorage/images/Screenshot 2024-02-05 214411.png>)

## Recreating Web3.py Script in Brownie

- Call initial retrieve() function
- Update with new value of 15

```py
def deploy_simple_storage():
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    # simple_storage.wait(1)
    stored_value = simple_storage.retrieve()
```

retrieve() is a view function, no need to add 'from: account'

![alt text](<brownie_simplestorage/images/Screenshot 2024-02-05 215605.png>)

#### Update this value



![alt text](<brownie_simplestorage/images/Screenshot 2024-02-05 222225.png>)

```js
def deploy_simple_storage():
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    # simple_storage.wait(1)
    stored_value = simple_storage.retrieve()
    print(stored_value)
    transaction = simple_storage.store(15, {"from": account})
    transaction.wait(1) # num of blocks to wait
    updated_stored_value = simple_storage.retrieve()
    print(updated_stored_value)
```

## Testing

Automate and check that our contracts are doing what we want them to do without always manually checking. Check 15 update, etc.

1. Make new file in tests\ folder
    - File names need 'test' at beginning
2. Define tests
    - Test to see that when we deploy smart contract, starts with 0 in retrieve() function
    - Arrange, Act, Assert
    1. Arrange
        - Get account address
    2. Act
        - Deploy contract
        - Get starting value
        - Add expected value
    3. Assert
        - Asser that starting value equals expected
3. brownie test
    - Every passed test gets a green dot

```py
from brownie import SimpleStorage, accounts

def test_deploy():
    # Arrange
    account = accounts[0]
    # Act
    simple_storage = SimpleStorage.deploy({"from": account})
    starting_value = simple_storage.retrieve()
    expected = 0
    # Assert
    assert starting_value == expected
```

### Test Updating with Value 15

1. Arrange
    - Get account
    - Deploy Smart Contract
2. Act
    - Expected value (15)
    - store() function 
3. Assert
    - expected value equals retrieve() value

```py
def test_updating_storage():
    # Arrange
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})
    # Act
    expected = 15
    simple_storage.store(expected, {"from": account})
    # Assert
    assert expected == simple_storage.retrieve()
```

Basically:
- Want to store 15 in our smart contract
- When we call retrieve, should be stored correctly

### Testing Tips

#### Test One Function
- brownie test -k test_updating_storage

#### Python Shell Test

- brownie test --pdb

Puts you in Python shell to:
- Check variables

![alt text](<brownie_simplestorage/images/Screenshot 2024-02-05 224132.png>)

What really went wrong? Why is my test failing?

#### Bonus Test Details

- brownie test -s

![alt text](<brownie_simplestorage/images/Screenshot 2024-02-06 103859.png>)

#### Everything that can be done in Brownie test comes directly from pytest

## Deploy to a Testnet

Brownie networks list.
- brownie networks list

Difference between 'Development' networks and 'Ethereum' networks:
- Default to development
- Development networks are temporary (like ganache)
- Contracts and txs sent on these blockchains are deleted after script completes
- Ethereum network contracts/txs persist
- Brownie keeps track of ETH deployments

RPC URL / HTTP Provider:
- Get into our package via env variable

1. https://dashboard.alchemy.com/
2. Create new app
3. Click 'API Key'
4. Paste to .env
    - export WEB3_ALCHEMY_PROJECT_ID=An1bl66-xqC_dOPd4OoxQ9YE18sp05T9
5. brownie networks add "Ethereum" "sepolia-alchemy" host=https://eth-sepolia.g.alchemy.com/v2/An1bl66-xqC_dOPd4OoxQ9YE18sp05T9 chainid=1115511 
    - [Brownie add network docs](https://eth-brownie.readthedocs.io/en/stable/network-management.html)
6. brownie run scripts/deploy.py --network sepolia-alchemy

deploy.py updates:
- from brownie import network
- new test:
```py
def get_account():
    if network.show_active() == "development":
        return accounts[0]
```

```py
def deploy_simple_storage():
    account = get_account()
```

![alt text](<brownie_simplestorage/images/Screenshot 2024-02-06 111720.png>)

![alt text](<brownie_simplestorage/images/Screenshot 2024-02-06 111933.png>)

### build/deployments

build/deployments/1115511/{}
- our deployment has been saved here by Brownie!

### Interacting with contracts deployed inside our brownie project

scripts/read_value.py

Reads directly from sepolia blockchain, reads from contract we've already deployed.

SimpleStorage contract is actually just an array:

```py
from brownie import SimpleStorage, accounts, config

def read_contract():
    print(SimpleStorage)

def main():
    read_contract()
```

1. brownie run .\scripts\read_value.py --network sepolia-alchemy
2. <brownie.network.contract.ContractContainer object at 0x000002206054D460>

This object works the same as an array. Can access indexes inside of it.

```py
def read_contract():
    print(SimpleStorage[0])
```
3. brownie run deploy scrips read_value.py --network sepolia-alchemy
4. 0x050F0FEe449A9EDc44A8201A9e5a5A80B8d4B5Af
    - Check on etherscan- this is the contract we just deployed!

Now we can just directly interact with this contract.

```py
def read_contract():
    print(SimpleStorage[-1])
```

The -1 index always gives us the most recently deployment.

Need ABI & Address to work with the smart contract?
- Brownie already knows what the address of the contract is. Saved in the deployments folder.
- Knows ABI from contracts/json file

```py
from brownie import SimpleStorage, accounts, config

def read_contract():
    simple_storage = SimpleStorage[-1]
    print(simple_storage.retrieve())

def main():
    read_contract()
```

Retrieves 15!

## Brownie Console

We typically write scripts when we want something to be reproducible, done over and over again.

- deploy SimpleStorage
- read value
- etc.

But maybe we wanna go adhoc, get into a shell to interact with these contracts.

#### brownie console

Opens console with all our contracts and everything else already imported.

1. SimpleStorage
    - returns empty array
    - since we're working in new local test env, no SimpleStorage contracts deployed
2. account = accounts[0]
3. account
    - returns <Account '0x66aB6D9362d4F35596279692F0251Db635165871'>
    - everything imported via brownie in our script is auto-imported into brownie console shell
4. Deploy SimpleStorage contract
    - simple_storage = SimpleStorage.deploy({"from": account})
    - returns same as running script!

![alt text](<brownie_simplestorage/images/Screenshot 2024-02-06 113726.png>)

5. simple_storage
    - returns <SimpleStorage Contract '0x3194cBDC3dbcd3E11a07892e7bA5c3394048Cc87'>
6. len(SimpleStorage)
    - returns 1
7. deploy again to get 2nd deployment
8. simple_storage.retrieve()
9. simple_storage.store(15, {"from": account})

