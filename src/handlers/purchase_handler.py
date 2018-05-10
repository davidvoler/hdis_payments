from tornado import web
from json import dumps, loads
from utils.w3_hdis import purchaseContent

PUBLIC_KEY="0x802f75067b7502FCF18ffA6B43A143f37ac47fc2"
PRIVATE_KEY="0xcc9da801e2338bbf9fe025e06fe55eb5a055651d270483b2161e8f9b011ba3c1"

class PurchaseHandler(web.RequestHandler):
    def get(self):
      student_public_key  = self.get_argument('public_key', PUBLIC_KEY)
      student_private_key = self.get_argument('private_key', PRIVATE_KEY)
      content_id          = self.get_argument('content_id')
      #permited = has_access(student_public_key, content_id)
      purchaseContent(content_id, student_private_key, student_public_key)
      self.write("Purchased")
