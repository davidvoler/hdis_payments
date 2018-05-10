from tornado import web
import json
from utils.db import get_db_client

class BaseHandler(web.RequestHandler):
    def get_current_user(self):
        return "Jonathan"
        #return self.get_secure_cookie("user")
    def get_db(self):
      return get_db_client()['hdis']
