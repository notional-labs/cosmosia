# https://gist.github.com/Jegeva/dafe74058ea30495c84c536a142a1144

import http.server
import socketserver
import urllib.request
import shutil
import os
import hashlib
import signal
import pathlib

cache_base = str(pathlib.ath.home()) + "/proxy_cache_data/"
httpd = None


def exit_gracefully(sig, stack):
    # print("received sig %d, quitting" % (sig))
    httpd.server_close()
    exit()


class CacheHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        m = hashlib.md5()

        url = self.path
        if len(url) > 0:
            url = url[1:]

        m.update(self.path.encode("utf-8"))
        cache_filename = cache_base + m.hexdigest() + ".cached"

        if not os.path.exists(cache_filename):
            print("cache miss " + url)
            with open(cache_filename + ".temp", "wb") as output:
                # print(url)
                req = urllib.request.Request(url)
                for k in self.headers:
                    if k not in ["Host"]:
                        req.add_header(k, self.headers[k])

                try:
                    resp = urllib.request.urlopen(req)
                    shutil.copyfileobj(resp, output)
                    os.rename(cache_filename + ".temp", cache_filename)
                except urllib.error.HTTPError as err:
                    self.send_response(err.code)
                    self.end_headers()
                    return

        print("cache hit " + url)
        with open(cache_filename, "rb") as cached:
            self.send_response(200)
            self.end_headers()
            shutil.copyfileobj(cached, self.wfile)


signal.signal(signal.SIGINT, exit_gracefully)
signal.signal(signal.SIGTERM, exit_gracefully)
socketserver.TCPServer.allow_reuse_address = True
httpd = socketserver.TCPServer(("", 8080), CacheHandler)
if not os.path.exists(cache_base):
    os.mkdir(cache_base)

httpd.serve_forever()
