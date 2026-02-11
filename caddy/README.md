# caddy

- コンテナ内で `Caddy` によりルート証明書とサーバー証明書を発行します
- コンテナ内の `Caddy` で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します

ディレクトリ構成

```
.
├── Caddyfile
├── README.md
├── certs
│   └── caddy_Development_Root_CA.crt
├── compose.yaml
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

コンテナを起動して以下を実行しルート証明書をコンテナから取り出す

```
$ docker compose exec caddy \
cat /data/caddy/pki/authorities/local/root.crt > certs/caddy_Development_Root_CA.crt
```

Caddyで作成されたルート証明書をホストPCに登録

```
$ sudo cp certs/caddy_Development_Root_CA.crt /usr/local/share/ca-certificates/
$ ls -l /usr/local/share/ca-certificates/caddy_Development_Root_CA.crt 
-rw-r--r-- 1 root root 631  2月 10 20:53 /usr/local/share/ca-certificates/caddy_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://localhost/
HTTP/1.1 308 Permanent Redirect
Connection: close
Location: https://localhost/
Server: Caddy
Date: Mon, 09 Feb 2026 15:44:29 GMT
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost/
HTTP/2 200 
accept-ranges: bytes
alt-svc: h3=":443"; ma=2592000
content-type: text/html; charset=utf-8
etag: "dgajf645et82p"
last-modified: Mon, 09 Feb 2026 15:31:14 GMT
server: Caddy
vary: Accept-Encoding
content-length: 25
date: Mon, 09 Feb 2026 15:44:44 GMT
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/caddy_Development_Root_CA.crt` をインポートします
