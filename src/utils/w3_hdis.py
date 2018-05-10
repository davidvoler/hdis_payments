from web3 import Web3
import json

DEFAULT_HOSTNAME = "https://rinkeby.infura.io"
DEFAULT_CONTRACT = Web3.toChecksumAddress("0x88e29d26fddef193983ec64cb49c7f4fd165bd28")
ABI=json.load(open("../interface", "r"))

class HDIS_W3():
    def __init__(self, hostname = DEFAULT_HOSTNAME, contract = DEFAULT_CONTRACT):
        self.provider = Web3.HTTPProvider(hostname)
        self.ws = Web3(self.provider)
        if self.ws.isConnected():
            print("Connected to provider {0}".format(hostname))


if __name__ == "__main__":
    hdis_w3 = HDIS_W3()
    print(hdis_w3)
    dir(hdis_w3)
