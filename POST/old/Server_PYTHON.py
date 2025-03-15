import http.server
import socketserver

PORT = 8000  # 使用するポート番号

class CustomHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def log_request_info(self):
        self.log_message("%s %s\n%s", self.command, self.path, self.headers)

    def do_GET(self):
        self.log_request_info()
        super().do_GET()

    def do_POST(self):
        self.log_request_info()
        # 必要ならPOSTデータを読み取る
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        self.log_message("POSTデータ: %s", post_data.decode('utf-8'))
        # クライアントにレスポンスを返す
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(b"POST request received")

Handler = CustomHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
