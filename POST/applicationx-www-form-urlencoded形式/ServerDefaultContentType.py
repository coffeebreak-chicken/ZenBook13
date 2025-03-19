import http.server
import socketserver
import urllib.parse  # データをパースするために必要

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
        headers = {key: value for key, value in self.headers.items()}
        print("Headers received:\n", headers)

        # コンテンツの長さを取得し、リクエストボディを読み取る
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')
        print("Raw Body received:\n", post_data)

        # application/x-www-form-urlencoded形式のデータをパース
        parsed_data = urllib.parse.parse_qs(post_data)
        print("Parsed Body received:\n", parsed_data)

        # レスポンスの準備
        self.send_response(200)  # ステータスコード200 OK
        self.send_header("Access-Control-Allow-Origin", "*")  # CORS対応
        self.send_header("Content-type", "text/plain; charset=utf-8")  # 平文形式でUTF-8対応
        self.end_headers()

        # レスポンスデータの作成（改行に注意）
        response_lines = []

        # ヘッダーを追記
        response_lines.append("Headers:")
        for key, value in headers.items():
            response_lines.append(f"{key}: {value}")

        # 生データを追記
        response_lines.append("\nRaw Body:")
        response_lines.append(post_data)

        # パース済みデータを追記
        response_lines.append("\nParsed Body:")
        for key, value in parsed_data.items():
            response_lines.append(f"{key}: {', '.join(value)}")

        # 改行を含めたレスポンスを作成
        response = "\r\n".join(response_lines)  # "\r\n"を使用して改行を明示

        # 平文でレスポンスを送信
        self.wfile.write(response.encode('utf-8'))

# サーバーを起動
with socketserver.TCPServer(("", PORT), CustomHTTPRequestHandler) as httpd:
    print(f"Serving at port {PORT}")
    httpd.serve_forever()
