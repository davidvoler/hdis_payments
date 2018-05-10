from tornado import ioloop, web
import re
from tornado.options import define, options, parse_command_line, parse_config_file
from handlers.dashboard_handler import DashboardHandler
from handlers.content_handler import ContentHandler
from handlers.content_by_id_handler import ContentbyIdHandler
from handlers.purchase_handler import PurchaseHandler
from handlers.add_contributor_handler import AddContributorHandler

define("port", default=6666, help="run on port", type=int)
define("mongo_host", default='localhost', help="mongo host", type=str)
define("mongo_port", default=27017, help="mongo port", type=int)
define("mongo_db_name", default='tracker', help="mongo database name", type=str)

def api():
    return web.Application([
        (r"/api/dashboard", DashboardHandler),
        (r"/api/content", ContentHandler),
        (r"/api/content_by_id", ContentbyIdHandler),
        (r"/api/purchase", PurchaseHandler),
        (r"/api/contributor", AddContributorHandler),
    ])

if __name__ == "__main__":
    app = api()
    app.listen(8888)
    print ("Payment running on port 8888")
    ioloop.IOLoop.current().start()
