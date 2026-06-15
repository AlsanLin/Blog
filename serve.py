from http.server import SimpleHTTPRequestHandler
from socketserver import ThreadingTCPServer
import os, mimetypes

os.chdir(r"C:\Users\45409\Documents\FreeWork\blog")

class H(SimpleHTTPRequestHandler):
    extensions_map = {**SimpleHTTPRequestHandler.extensions_map, '.md': 'text/markdown'}
    def end_headers(self):
        ct = self.headers.get('Content-Type', '')
        if ct.startswith('text/') and 'charset' not in ct:
            self.send_header('Content-Type', ct + '; charset=utf-8')
        super().end_headers()
    def log_message(self, f, *a): pass

s = ThreadingTCPServer(("127.0.0.1", 8080), H)
print(f"Blog: http://127.0.0.1:8080")
s.serve_forever()