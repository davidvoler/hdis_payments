from tornado import web
import json
from utils.w3_hdis import getContentById

PUBLIC_KEY="0x802f75067b7502FCF18ffA6B43A143f37ac47fc2"
PRIVATE_KEY="0xcc9da801e2338bbf9fe025e06fe55eb5a055651d270483b2161e8f9b011ba3c1"

class ContentbyIdHandler(web.RequestHandler):
    def get(self):
        id = self.get_argument("id")
        try:
          rs = getContentById(id, PRIVATE_KEY, PUBLIC_KEY)
          self.write(json.dumps({"Content":rs}))
        except Exception as e:
          self.set_status(500, str(e))
          self.write(json.dumps({"error":str(e)}))