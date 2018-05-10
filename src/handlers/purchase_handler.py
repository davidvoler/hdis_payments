from tornado import web
from json import dumps, loads
from utils.web3 import purchese_content, has_access

class PurchaseHandler(web.RequestHandler):
    def post(self):
      self.write("Create hdis content")
    def get(self):
      user_address = self.get_argument('student_address', "")
      content_id = self.get_argument('content_id', "")
      permited = has_access(user_address,content_id)
      self.write(dumps({"permited":permited}))