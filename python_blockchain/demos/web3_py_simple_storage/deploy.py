
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

# Now: Connect to Sepolia | Before: Connect to ganache
w3 = Web3(Web3.HTTPProvider("https://eth-sepolia.g.alchemy.com/v2/An1bl66-xqC_dOPd4OoxQ9YE18sp05T9"))
chain_id = 11155111
my_address = "0x9c1B089A7307B118d65F9844388CAB3ed8e90Fd9"
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