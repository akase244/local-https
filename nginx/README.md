# nginx-https

ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── certs
│   ├── openssl.cnf
│   ├── snakeoil.crt
│   └── snakeoil.key
├── compose.yaml
├── default.conf
├── entrypoint.sh
└── html
    └── index.html
```

コンテナの作成と起動

```
$ docker compose up -d
```

コンテナの起動

```
$ docker compose start
```

コンテナの停止

```
$ docker compose stop
```

コンテナの削除

```
$ docker compose down
```

Dockerコンテナ内で作成されたCA証明書として機能するサーバー証明書をホスト側に登録

```
$ sudo cp certs/snakeoil.crt /usr/local/share/ca-certificates/nginx_rootCA.crt
$ ls -l /usr/local/share/ca-certificates/nginx_rootCA.crt
-rw-r--r-- 1 root root 2122  2月 11 00:08 /usr/local/share/ca-certificates/nginx_rootCA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://127.0.0.1/
HTTP/1.1 301 Moved Permanently
Server: nginx/1.28.2
Date: Tue, 10 Feb 2026 15:08:37 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://127.0.0.1/
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://127.0.0.1/
HTTP/1.1 200 OK
Server: nginx/1.28.2
Date: Tue, 10 Feb 2026 15:09:02 GMT
Content-Type: text/html
Content-Length: 25
Last-Modified: Mon, 09 Feb 2026 15:26:14 GMT
Connection: keep-alive
ETag: "6989fc96-19"
Accept-Ranges: bytes
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/snakeoil.crt` をインポートします
