import http.server
import socketserver
import json

PORT = 8080

class CustomHTTPRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Custom-Header, X-Requested-With")
        self.end_headers()

    def do_POST(self):
        try:
            # リクエストヘッダーを取得
            headers = self.headers.as_string()
            print("Headers received:\n", headers)
            
            # リクエストボディの取得
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length).decode('utf-8')
            print("Body received:\n", post_data)
            
            # レスポンスの準備
            self.send_response(200)
            self.send_header("Access-Control-Allow-Origin", "*")  # すべてのオリジンからのアクセスを許可
            self.send_header("Content-type", "application/json")
            self.end_headers()
            
            # レスポンスデータの作成
            response = {
                "headers": headers,
                "body": post_data
            }
            
            # レスポンスの送信
            self.wfile.write(json.dumps(response).encode('utf-8'))

        except Exception as e:
            # エラーハンドリング
            self.send_response(500)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            error_response = {
                "error": "An error occurred while processing the request",
                "details": str(e)
            }
            self.wfile.write(json.dumps(error_response).encode('utf-8'))
            print(f"An error occurred: {e}")

Handler = CustomHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving at port {PORT}")
    httpd.serve_forever()
