from tornado import ioloop, web
import re
import pymongo
from handlers import  AccountHandler, TransactionHandler

import config.settings

from tornado.options import define, options, parse_command_line, parse_config_file




def api():
    return web.Application([
        (r"/api/account", AccountHandler),
        (r"/api/transaction", TransactionHandler),
    ])

if __name__ == "__main__":
    parse_command_line()
    try:
        parse_config_file('/conf/api_stub.conf')
    except:
        pass
    app = api()
    app.listen(options.port)

    print ("Payment running on port {}".format(options.port))
    ioloop.IOLoop.current().start()
