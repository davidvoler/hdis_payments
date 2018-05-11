from tornado import web
import json
from utils.w3_hdis import addContent

PUBLIC_KEY="0x802f75067b7502FCF18ffA6B43A143f37ac47fc2"
PRIVATE_KEY="0xcc9da801e2338bbf9fe025e06fe55eb5a055651d270483b2161e8f9b011ba3c1"

class ContentHandler(web.RequestHandler):
    def get(self):
        name       = self.get_argument("name")
        media_id   = self.get_argument("media_id", "1")
        media_type = self.get_argument("media_type", "1")
        creator    = self.get_argument("creator", PUBLIC_KEY)
        price      = self.get_argument("price", "100")
        try:
          rs = addContent(name, media_id, media_type, creator, price, PRIVATE_KEY, PUBLIC_KEY)
          self.write(json.dumps({"content_id":rs}))
        except Exception as e:
          self.set_status(500, str(e))
          self.write(json.dumps({"error":str(e)}))          