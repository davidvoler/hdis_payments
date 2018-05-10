from tornado import web
import json
from utils.web3 import list_content,create_content

class ContentHandler(web.RequestHandler):
    def post(self):
      create_content()
      self.write("Create hdis content")
    def get(self):
      contents = list_content()
      self.write(json.dumps(contents))