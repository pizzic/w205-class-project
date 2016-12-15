#!/usr/bin/env python3

import sys
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from PyQt4.QtWebKit import *

import csv
import re
import bs4 as bs
import urllib.request
from lxml import html

if len(sys.argv) < 2:
    quit()
else:
    num = sys.argv[1]

# Storing all URLs in a list
urls = []

states_1 = ["AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","HI","IA","ID","IL","IN","KS"]
states_2 = ["KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM"]
states_3 = ["NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY"]
# all_states = ["AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","HI","IA","ID","IL","IN","KS","KY","LA","MA","MD","ME","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VA","VT","WA","WI","WV","WY"]

groups = {"1":states_1, "2":states_2, "3":states_3}
states = groups[num]

# Creating CSV file
outputFile = open('Hospital Safety Grade - Part ' + num + '.csv', 'w', newline='')
outputWriter = csv.writer(outputFile)
outputWriter.writerow(['Name', 'Address', 'City', 'State', 'ZipCode', 'Grade'])

for state in states:
    url = 'http://www.hospitalsafetygrade.org/search?findBy=state&zip_code=&city=&state_prov=' + state + '&hospital='
    urls.append(url)
    print(url)

# Class to capture the HTML
class Render(QWebPage):
  def __init__(self, urls, cb):
    self.app = QApplication(sys.argv)
    QWebPage.__init__(self)
    self.loadFinished.connect(self._loadFinished)
    self.urls = urls
    self.cb = cb
    self.crawl()
    self.app.exec_()

  def crawl(self):
    if self.urls:
      url = self.urls.pop(0)
      print('Downloading', url)
      self.mainFrame().load(QUrl(url))
    else:
      self.app.quit()

  def _loadFinished(self, result):
    frame = self.mainFrame()
    url = str(frame.url().toString())
    html = frame.toHtml()
    self.cb(url, html)
    self.crawl()

# Removes unnecessary HTML tags and formatting
def cleanhtml(raw_html):
  cleanr = re.compile('<.*?>')
  cleantext = re.sub(cleanr, '', raw_html).replace("[", "").replace("]", "").strip()
  cleantext = ' '.join(cleantext.split())
  return cleantext

# Scrapes state, name, address, and grade information and writes to the CSV file
def scrape(url, html):
    soup = bs.BeautifulSoup(html, 'lxml')

    # pull out all hospital matches
    search_results = soup.find_all("div", {"class": "itemWrapper leapfrogSearchResult"})
    print(search_results)

    for search_result in search_results:
        state = str(url[-12:-10])
        name = cleanhtml(str(search_result.contents[1].find_all(True, {"class":["name"]})).replace("\n", ""))
        raw_address = str(search_result.contents[1].find_all(True, {"class":["address"]})).replace("\n", "")
        address = cleanhtml(raw_address.split("<br/>")[0])
        city = cleanhtml(raw_address.split("<br/>")[1].split(",")[0])
        zip_code = cleanhtml(raw_address.split("<br/>")[1].split(",")[1].strip()[2:].strip())
        grade = str(search_result.contents[3])[31:32].replace("\n", "").upper()
        outputWriter.writerow([name, address, city, state, zip_code, grade])

# Running the code
Render(urls, cb=scrape)
outputFile.close()
print("Done")
