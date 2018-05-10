from tornado import web
from json import dumps, loads
from utils .web3 import list_students, create_student

class ContentHandler(web.RequestHandler):
    def post(self):
      student_id = self.get_argument('student_id')
      res = create_student(student_id)
      self.write(dumps(res))
    def get(self):
      student_list = list_students()
      self.write(dumps(student_list))
      