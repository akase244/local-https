# nginx-https

- コンテナ内でルート証明書とサーバー証明書を発行します
- コンテナ内で作成されたルート証明書をホストPCに登録することで自己署名証明書の警告を抑制します

ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── certs
│   ├── openssl.cnf
│   ├── snakeoil.crt
│   ├── snakeoil.csr
│   ├── snakeoil.key
│   ├── snakeoil_Development_Root_CA.crt
│   ├── snakeoil_Development_Root_CA.key
│   └── snakeoil_Development_Root_CA.srl
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

Dockerコンテナ内で作成されたルート証明書をホストPCに登録

```
$ sudo cp certs/snakeoil_Development_Root_CA.crt /usr/local/share/ca-certificates/nginx_snakeoil_Development_Root_CA.crt
$ ls -l /usr/local/share/ca-certificates/nginx_snakeoil_Development_Root_CA.crt
-rw-r--r-- 1 root root 2033  2月 11 00:51 /usr/local/share/ca-certificates/nginx_snakeoil_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://127.0.0.1/
HTTP/1.1 301 Moved Permanently
Server: nginx/1.28.2
Date: Wed, 11 Feb 2026 02:29:56 GMT
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

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/snakeoil_Development_Root_CA.crt` をインポートします
