import requests
from bs4 import BeautifulSoup

url = "http://www.lib.kmust.edu.cn/kmustlib/"
connect_web = requests.get(url)
print(connect_web.raise_for_status)

web_constant = BeautifulSoup(connect_web.text, "html.parser")
print(web_constant)