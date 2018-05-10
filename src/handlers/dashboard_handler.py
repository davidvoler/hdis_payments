from tornado import web
import json

class DashboardHandler(web.RequestHandler):
    def get(self):
      data={
        'students':[
          {"id":1,"name":"Marie"},
          {"id":2,"name":"Joe"},
          {"id":3,"name":"Hana"},
        ],
        'contnent':[
          {"id":1},
          {"id":2},
          {"id":3},
          {"id":4},
        ],
        'payments':[
          {'sudentId':1,'contentId':1},
          {'sudentId':2,'contentId':1},
          {'sudentId':3,'contentId':3},
        ]
      }
      self.write(json.dumps(data))