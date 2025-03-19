import http.server
import socketserver

PORT = 8080

class CustomHTTPRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, Custom-Header, X-Requested-With")
        self.end_headers()

    def do_POST(self):
        # リクエストヘッダーを取得
        headers = self.headers.as_string() # これ生？
        print("Headers received:\n", headers)
        
        # コンテンツの長さを取得してリクエストボディを読み取る
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8') # これ生？
        print("Body received:\n", post_data)
        
        # レスポンスの準備
        self.send_response(200) # ステータスコード200 OKを設定
        self.send_header("Access-Control-Allow-Origin", "*")  # CORSヘッダーを設定
        self.send_header("Content-type", "application/json") # Content-Typeを設定
        self.end_headers() # レスポンスヘッダーの準備を閉じる
        
        # レスポンスデータの作成
        response = {
            "headers": headers,
            "body": post_data
        }
        
        # レスポンスの送信
        self.wfile.write(json.dumps(response).encode('utf-8'))

# Handler = CustomHTTPRequestHandler

with socketserver.TCPServer(("", PORT), CustomHTTPRequestHandler) as httpd: # "" は、デフォルトでローカルホスト（localhost）にバインドされる
    print(f"Serving at port {PORT}")
    httpd.serve_forever()
