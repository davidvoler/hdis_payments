import web3
from web3 import Web3, HTTPProvider, TestRPCProvider
from solc import compile_source
from web3.contract import ConciseContract

w3_ws = None
w3_http = None
CONTRACT_ADDESS = ""
contract_interface = {}


def get_http_w3(hostname="http://localhost"):
  global w3_http
  if not w3_http:
    my_provider = Web3.HTTPProvider(hostname)
    w3_http = Web3(my_provider)
    print(w3_http.isConnected())  
  return w3_http


def get_ws_w3(hostname="ws://127.0.0.1:8546"):
  global w3_ws
  if not w3_ws:
    provider = Web3.WebsocketProvider(hostname)
    w3_ws = Web3(provider)
    print(w3_ws.isConnected())  
  return w3_ws

  
def get_contract_instance(contract_address, contract_interface, contract_factory_class):
  http_w3 = get_http_w3()
  abi = contract_interface['abi']
  contract_instance = http_w3.eth.contract(address=contract_address, abi=abi,ContractFactoryClass=contract_factory_class)
  return contract_instance;

#Content utility function
def create_content(contract_address, contract_interface, contract_factory_class, data, account):
  contract_instance = get_contract_instance((contract_address, contract_interface, contract_factory_class)
  contract_instance.createContent(data, transact={'from': account})

def list_content(contract_address, contract_interface, contract_factory_class)
  contract_instance = get_contract_instance((contract_address, contract_interface, contract_factory_class)
  contract_instance.listContent(transact={'from': account})

#student function 

def create_student(student_id):
  """Creates a new studetn
  
  Arguments:
    student_address {[type]} -- [description]
  """
  pass

def list_students():
  """Returns a list of students
  """
  pass

def has_access(contract_address, contract_interface, contract_factory_class, student_id, content_id)
  contract_instance = get_contract_instance((contract_address, contract_interface, contract_factory_class)
  contract_instance.hasAccess(student_id, content_id)  


def purchese_content(contract_address, contract_interface, contract_factory_class, content_id, account)
  contract_instance = get_contract_instance((contract_address, contract_interface, contract_factory_class)
  contract_instance.purcheseContent(content_id, transact={'from': account})
  
  
