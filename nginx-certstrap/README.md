# nginx-certstrap

- コンテナ内で `certstrap` コマンドを利用してルート証明書とサーバー証明書を発行します
- コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します

ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── certs
│   ├── snakeoil.crt
│   ├── snakeoil.key
│   ├── snakeoil_Development_Root_CA.crt
│   └── snakeoil_Development_Root_CA.key
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
$ sudo cp certs/snakeoil_Development_Root_CA.crt /usr/local/share/ca-certificates/nginx-certstrap_snakeoil_Development_Root_CA.crt
$ ls -l /usr/local/share/ca-certificates/nginx-certstrap_snakeoil_Development_Root_CA.crt
-rw-r--r-- 1 root root 2061  2月 12 16:26 /usr/local/share/ca-certificates/nginx-certstrap_snakeoil_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://localhost/
HTTP/1.1 301 Moved Permanently
Server: nginx/1.28.2
Date: Thu, 12 Feb 2026 07:35:21 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://localhost/
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost/
HTTP/1.1 200 OK
Server: nginx/1.28.2
Date: Thu, 12 Feb 2026 07:35:42 GMT
Content-Type: text/html
Content-Length: 29
Last-Modified: Thu, 12 Feb 2026 06:32:34 GMT
Connection: keep-alive
ETag: "698d7402-1d"
Accept-Ranges: bytes
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/snakeoil_Development_Root_CA.crt` をインポートします
