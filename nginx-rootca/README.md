# nginx-https

ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── certs
│   ├── openssl.cnf
│   ├── rootCA.crt
│   ├── rootCA.key
│   ├── rootCA.srl
│   ├── snakeoil.crt
│   ├── snakeoil.csr
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
$ sudo cp certs/rootCA.crt /usr/local/share/ca-certificates/nginx_rootCA.crt
$ ls -l /usr/local/share/ca-certificates/nginx_rootCA.crt
-rw-r--r-- 1 root root 2033  2月 11 00:51 /usr/local/share/ca-certificates/nginx_rootCA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I https://127.0.0.1/
HTTP/1.1 200 OK
Server: nginx/1.28.2
Date: Tue, 10 Feb 2026 15:52:14 GMT
Content-Type: text/html
Content-Length: 32
Last-Modified: Tue, 10 Feb 2026 15:49:02 GMT
Connection: keep-alive
ETag: "698b536e-20"
Accept-Ranges: bytes
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://127.0.0.1/
HTTP/1.1 200 OK
Server: nginx/1.28.2
Date: Tue, 10 Feb 2026 15:53:01 GMT
Content-Type: text/html
Content-Length: 32
Last-Modified: Tue, 10 Feb 2026 15:49:02 GMT
Connection: keep-alive
ETag: "698b536e-20"
Accept-Ranges: bytes
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/rootCA.crt` をインポートします
