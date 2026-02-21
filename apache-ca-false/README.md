# apache-ca-false

- TLS終端: Apache
- webサーバー: Apache
- コンテナ内で `openssl` コマンドを利用してルート証明書とサーバー証明書を発行します
- コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します

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
├── entrypoint.sh
├── html
│   └── index.html
└── httpd.conf
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
$ curl -I http://127.0.0.1/
HTTP/1.1 301 Moved Permanently
Date: Wed, 11 Feb 2026 03:32:26 GMT
Server: Apache/2.4.66 (Unix) OpenSSL/3.5.4
Location: https://localhost/
Content-Type: text/html; charset=iso-8859-1
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://127.0.0.1/
HTTP/1.1 200 OK
Date: Wed, 11 Feb 2026 03:32:47 GMT
Server: Apache/2.4.66 (Unix) OpenSSL/3.5.4
Last-Modified: Mon, 09 Feb 2026 15:26:14 GMT
ETag: "1a-64a65c26ffeac"
Accept-Ranges: bytes
Content-Length: 26
Content-Type: text/html
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/snakeoil_Development_Root_CA.crt` をインポートします
