from tornado import web
import json

class ContentHandler(web.RequestHandler):
    def post(self):
      self.write("Create hdis content")
    def get(self):
      self.write("get a list of content")