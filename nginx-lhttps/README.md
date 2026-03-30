# nginx-lhttps

- TLS終端: Nginx
- webサーバー: Nginx
- コンテナ内で `php lh create` コマンドを利用してルート証明書とサーバー証明書を発行します
- コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します

ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── certs
│   ├── snakeoil.crt
│   ├── snakeoil.key
│   └── snakeoil_Development_Root_CA.crt
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
$ sudo cp certs/snakeoil_Development_Root_CA.crt /usr/local/share/ca-certificates/nginx-lhttps_snakeoil_Development_Root_CA.crt
$ ls -l /usr/local/share/ca-certificates/nginx-lhttps_snakeoil_Development_Root_CA.crt
-rw-r--r-- 1 root root 1383  3月 30 22:43 /usr/local/share/ca-certificates/nginx-lhttps_snakeoil_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://localhost/
HTTP/1.1 301 Moved Permanently
Server: nginx/1.29.5
Date: Mon, 30 Mar 2026 13:45:08 GMT
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
Date: Mon, 30 Mar 2026 13:45:26 GMT
Content-Type: text/html
Content-Length: 26
Last-Modified: Sun, 29 Mar 2026 17:04:56 GMT
Connection: keep-alive
ETag: "69c95bb8-1a"
Accept-Ranges: bytes
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/snakeoil_Development_Root_CA.crt` をインポートします
