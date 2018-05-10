from tornado import ioloop, web
import re
import pymongo
from handlers.dashboard_handler import  DashboardHandler




def api():
    return web.Application([
        (r"/api/dashboard", DashboardHandler),
    ])

if __name__ == "__main__":
    app = api()
    app.listen(8888)
    print ("Payment running on port 8888")
    ioloop.IOLoop.current().start()
