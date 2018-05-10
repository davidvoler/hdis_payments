from tornado.gen import coroutine
from handlers.base import BaseHandler
from bson.json_util import dumps, loads
from bson.objectid import ObjectId


class EditExerciseHandler(BaseHandler):

    @coroutine
    def get_lesson_exercises(self, lesson_id):
        db = self.get_db()
        exercises = []
        cursor = yield db['exercises'].find({'lesson_id': ObjectId(lesson_id)})
        while (yield cursor.fetch_next):
            doc = cursor.next_object()
            doc['_id'] = str(doc['_id'])
            doc['lesson_id'] = str(doc['lesson_id'])
            exercises.append(doc)
        return exercises

    @coroutine
    def create_or_update(self, exercise, lesson_id):
        db = self.get_db()
        exercise_id = exercise.get('_id', None)
        if exercise_id:
            del exercise['_id']
            del exercise['lesson_id']
            res = db['exercises'].updated_one(
                {'_id': ObjectId(exercise_id)}, {'$set': exercise})
        else:
            exercise['lesson_id'] = ObjectId(lesson_id)
            res = db['exercises'].insert_one(exercise)
        return res

    @coroutine
    def get(self):
        lesson_id = self.get_argument('lesson_id', None)
        if lesson_id:
            exercises = yield self.get_lesson_exercises(lesson_id)
            self.write(dumps(exercises))
        else:
            self.write(dumps({"status": -2}))

    @coroutine
    def post(self):
        lesson_id = self.get_argument('lesson_id', None)
        exercise = loads(self.request.body)
        if lesson_id:
            new_exercise = yield self.get_lesson_exercises(lesson_id)
            exercises = yield self.create_or_update(exercise, lesson_id)
            data = {
                "exercise_list": exercises,
                "saved_id": new_exercise
            }
            self.write(dumps(data))
        else:
            self.write(dumps({"status": -2}))
