from tornado.gen import coroutine
from handlers.base import BaseHandler
from bson.json_util import dumps
from bson.objectid import ObjectId


class EditLessonHandler(BaseHandler):
    @coroutine
    def get(self):
        id = self.get_argument('id', None)
        if id:
            db = self.get_db()['hdis']
            lesson = yield db['lessons'].find_one({'_id': ObjectId(id)})
            lesson['id'] = str(lesson['_id'])
            self.write(dumps(lesson))
        else:
            self.write(dumps({"status": -2}))
