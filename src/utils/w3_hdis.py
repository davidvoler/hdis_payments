from web3 import Web3
import json

HOSTNAME = "https://ropsten.infura.io/"
CONTRACT_ADDRESS = Web3.toChecksumAddress("0xf8a15a2b41ab6a8165eed28c0ae97a26f8597092")
ABI=json.load(open("interface", "r"))

class HDIS_W3():
    def __init__(self):
        self.provider = Web3.HTTPProvider(HOSTNAME)
        self.w3 = Web3(self.provider)
        if self.w3.isConnected():
            print("Connected to provider {0}".format(HOSTNAME))
        else:
            return
        self.contract = self.w3.eth.contract(address = CONTRACT_ADDRESS, abi = ABI)
        print("Contract owner is {0}".format(self.contract.call().owner()))

    def addContent(self, name, media_id, media_type, creator, price):
        return self.contract.call().addContent(name, media_id, media_type, creator, price)


if __name__ == "__main__":
    hdis_w3 = HDIS_W3()
