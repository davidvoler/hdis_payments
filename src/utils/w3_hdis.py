from web3 import Web3
from web3.auto import w3
import json

HOSTNAME = "https://ropsten.infura.io/"
CONTRACT_ADDRESS = Web3.toChecksumAddress("0xf8a15a2b41ab6a8165eed28c0ae97a26f8597092")
ABI=json.load(open("solidity/interface", "r"))
PUBLIC_KEY="0x802f75067b7502FCF18ffA6B43A143f37ac47fc2"
PRIVATE_KEY="0xcc9da801e2338bbf9fe025e06fe55eb5a055651d270483b2161e8f9b011ba3c1"
CHAIN_ID=3 # Ropsten
GAS=1000000
GAS_PRICE=w3.toWei('10', 'gwei')

w3 = None
contract = None

def connect():
    global w3
    global contract
    provider = Web3.HTTPProvider(HOSTNAME)
    w3 = Web3(provider)
    if w3.isConnected():
        print("Connected to provider {0}".format(HOSTNAME))
    else:
        return
    contract = w3.eth.contract(address = CONTRACT_ADDRESS, abi = ABI)

def txn_data(public_key):
    global w3
    nonce = w3.eth.getTransactionCount(public_key)
    return {'chainId': CHAIN_ID, 'gas': GAS, 'gasPrice': GAS_PRICE, 'nonce': nonce,}

def send_txn(txn, private_key):
    global w3
    signed_txn = w3.eth.account.signTransaction(txn, private_key=private_key)
    return w3.eth.sendRawTransaction(signed_txn.rawTransaction)

def addContent(name, media_id, media_type, creator, price, private_key, public_key):
    global contract
    addContent_txn = contract.functions \
        .addContent(name, int(media_id), int(media_type), creator, int(price)) \
        .buildTransaction(txn_data(public_key))
    rv = send_txn(addContent_txn, private_key)
    return Web3.toInt(rv)

def getContentById(id, private_key, public_key):
    global contract
    getContentById_txn = contract.functions \
        .getContentById(int(id)) \
        .buildTransaction(txn_data(public_key))
    rv = send_txn(getContentById_txn, private_key)
    return rv

connect()
