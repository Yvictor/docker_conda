# Created on Jan, 9, 2017
# @author: Yvictor

from selenium import webdriver
from pyvirtualdisplay import Display

display = Display(visible=0, size=(1024, 768))
display.start()

driver = webdriver.Firefox()
test_url = "http://twtraffic.tra.gov.tw/twrail/"
driver.get(test_url)
print("Done Selenium Work Well.")