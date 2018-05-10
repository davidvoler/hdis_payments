from web3 import Web3
from web3.auto import w3
import json

HOSTNAME = "https://ropsten.infura.io/"
CONTRACT_ADDRESS = Web3.toChecksumAddress("0xf8a15a2b41ab6a8165eed28c0ae97a26f8597092")
ABI=json.load(open("interface", "r"))
PUBLIC_KEY="0x802f75067b7502FCF18ffA6B43A143f37ac47fc2"
PRIVATE_KEY="0xcc9da801e2338bbf9fe025e06fe55eb5a055651d270483b2161e8f9b011ba3c1"
CHAIN_ID=3 # Ropsten

class HDIS_W3():
    def __init__(self, private_key):
        self.private_key = private_key
        self.provider = Web3.HTTPProvider(HOSTNAME)
        self.w3 = Web3(self.provider)
        if self.w3.isConnected():
            print("Connected to provider {0}".format(HOSTNAME))
        else:
            return
        self.contract = self.w3.eth.contract(address = CONTRACT_ADDRESS, abi = ABI)
        print("Contract owner is {0}".format(self.contract.call().owner()))

    def txn_data(self):
        nonce = self.w3.eth.getTransactionCount(PUBLIC_KEY)
        return {'chainId': CHAIN_ID,
            'gas': 1000000,
            'gasPrice': w3.toWei('10', 'gwei'),
            'nonce': nonce,}

    def send_txn(self, txn):
        signed_txn = self.w3.eth.account.signTransaction(txn, private_key=PRIVATE_KEY)
        return self.w3.eth.sendRawTransaction(signed_txn.rawTransaction)

    def addContent(self, name, media_id, media_type, creator, price):
        addContent_txn = self.contract.functions \
            .addContent(name, media_id, media_type, creator, price) \
            .buildTransaction(self.txn_data())
        rv = self.send_txn(addContent_txn)
        return Web3.toInt(rv)

if __name__ == "__main__":
    hdis_w3 = HDIS_W3(PRIVATE_KEY)
    rv = hdis_w3.addContent("name", 1, 1, PUBLIC_KEY, 100)
    print(rv)
