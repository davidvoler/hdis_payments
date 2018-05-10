from motor.motor_tornado import MotorClient
from tornado.options import options

client = False

def get_db_client():
    global client
    if not client:
        client = MotorClient(options.mongo_host, options.mongo_port)
    return client