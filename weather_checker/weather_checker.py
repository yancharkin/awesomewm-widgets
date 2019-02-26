#!/usr/bin/env python
# -*- coding: utf-8; -*-

import sys
from bs4 import BeautifulSoup
import lxml
import signal

class TimeoutException(Exception): pass

def get_weather():
    """Returns current temperature"""
    def signal_timeout(signum, frame):
        """Handler for timeout signal"""
        raise TimeoutException("Time out.")

    with open(sys.path[0] + "/location", "r") as f:
        URL = f.readlines()[0].strip()
    try:
        from urllib2 import Request as urllib_request
        from urllib2 import urlopen as urllib_urlopen
        from urllib2 import URLError as urllib_urlerror
        from urllib2 import HTTPError as urllib_httperror
    except:
        from urllib.request import Request as urllib_request
        from urllib.request import urlopen as urllib_urlopen
        from urllib.request import URLError as urllib_urlerror
        from urllib.request import HTTPError as urllib_httperror

    req = urllib_request(URL)

    signal.signal(signal.SIGALRM, signal_timeout)
    signal.alarm(10) # Maximum execution time

    try:
        page = urllib_urlopen(req)
        page_content = page.read()
        soup = BeautifulSoup(page_content, "lxml")

        temperature = soup.find_all("span", attrs={"class":"summary"})[0].get_text().split()[0]
        icon_name = ""
        for tag in soup.find_all("span", attrs={"class":"currently"}):
            icon_name = tag.find_all("img")[0].get("alt").split()[0]

        output = temperature + "," + icon_name + ".svg"
        if sys.version_info.major == 2:
            output = output.encode("utf-8")
        print(output)
        return temperature, icon_name

    except TimeoutException as e:
        print(e)
        return 1
    except urllib_urlerror as e:
        print("Error")
        #print(e.reason)
        return e.reason
    except urllib_httperror as e:
        print("Error")
        #print(e.code)
        #print(e.read())
        return e.code, e.read()
    except:
        print("Error")
        return 1

if __name__ == "__main__":
    get_weather()
