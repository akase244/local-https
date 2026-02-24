# apache-nginx-ca-true

- TLS終端: Nginx
- webサーバー: Apache
- コンテナ内で `openssl` コマンドを利用してルート証明書（「basicConstraints=CA:TRUE」付きのサーバー証明書）を発行します
- コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します

ディレクトリ構成

```
.
├── README.md
├── apache
│   ├── Dockerfile
│   └── httpd.conf
├── certs
│   ├── openssl.cnf
│   ├── snakeoil.crt -> /etc/nginx/certs/snakeoil_Development_Root_CA.crt
│   ├── snakeoil.key -> /etc/nginx/certs/snakeoil_Development_Root_CA.key
│   ├── snakeoil_Development_Root_CA.crt
│   └── snakeoil_Development_Root_CA.key
├── compose.yaml
├── html
│   └── index.html
├── httpd.conf
└── nginx
    ├── Dockerfile
    ├── default.conf
    └── entrypoint.sh
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
$ sudo cp certs/snakeoil_Development_Root_CA.crt /usr/local/share/ca-certificates/apache-ca-false_snakeoil_Development_Root_CA.crt
$ ls -l /usr/local/share/ca-certificates/apache-ca-false_snakeoil_Development_Root_CA.crt
-rw-r--r-- 1 root root 2061  2月 11 12:32 /usr/local/share/ca-certificates/apache-ca-false_snakeoil_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://localhost
HTTP/1.1 301 Moved Permanently
Server: nginx/1.29.5
Date: Tue, 24 Feb 2026 14:27:19 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://localhost/
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost
HTTP/1.1 200 OK
Server: nginx/1.29.5
Date: Tue, 24 Feb 2026 14:27:23 GMT
Content-Type: text/html
Content-Length: 34
Connection: keep-alive
Last-Modified: Tue, 24 Feb 2026 14:26:59 GMT
ETag: "22-64b92ae21ed52"
Accept-Ranges: bytes
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/snakeoil_Development_Root_CA.crt` をインポートします
