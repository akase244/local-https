# nginx-minica

- コンテナ内で `minica` コマンドを利用してルート証明書とサーバー証明書を発行します
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
$ sudo cp certs/snakeoil_Development_Root_CA.crt /usr/local/share/ca-certificates/nginx-minica_snakeoil_Development_Root_CA.crt
$ ls -l /usr/local/share/ca-certificates/nginx-minica_snakeoil_Development_Root_CA.crt
-rw-r--r-- 1 root root 749  2月 12 23:37 /usr/local/share/ca-certificates/nginx-minica_snakeoil_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://localhost/
HTTP/1.1 301 Moved Permanently
Server: nginx/1.29.5
Date: Thu, 12 Feb 2026 14:38:13 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://localhost/
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost/
HTTP/1.1 200 OK
Server: nginx/1.29.5
Date: Thu, 12 Feb 2026 14:38:27 GMT
Content-Type: text/html
Content-Length: 26
Last-Modified: Thu, 12 Feb 2026 10:22:37 GMT
Connection: keep-alive
ETag: "698da9ed-1a"
Accept-Ranges: bytes
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/snakeoil_Development_Root_CA.crt` をインポートします
