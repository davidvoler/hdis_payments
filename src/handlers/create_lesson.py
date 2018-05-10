from  tornado.gen import coroutine
from handlers.base import BaseHandler
from bson.json_util import dumps, loads


class LessonHandler(BaseHandler):
    @coroutine
    def post(self):
      data = loads(self.request.body)
      db = self.get_db()['hdis']
      res = yield db['lessons'].insert_one(data)
      self.write(dumps({'status':1}))