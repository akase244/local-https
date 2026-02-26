# bottle-caddy

- TLS終端: Caddy 
- webサーバー: Bottle
- コンテナ内で `Caddy` によりルート証明書とサーバー証明書を発行します
- コンテナ内の `Caddy` で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します

ディレクトリ構成

```
.
├── Caddyfile
├── Dockerfile
├── README.md
├── app
│   └── app.py
├── certs
│   └── bottle-caddy_Development_Root_CA.crt
├── compose.yaml
├── entrypoint.sh
└── requirements.txt
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
$ docker compose exec reverse-proxy \
cat /data/caddy/pki/authorities/local/root.crt > certs/bottle-caddy_Development_Root_CA.crt
```

Caddyで作成されたルート証明書をホストPCに登録

```
$ sudo cp certs/bottle-caddy_Development_Root_CA.crt /usr/local/share/ca-certificates/
$ ls -l /usr/local/share/ca-certificates/bottle-caddy_Development_Root_CA.crt 
-rw-r--r-- 1 root root 631  2月 10 20:53 /usr/local/share/ca-certificates/bottle-caddy_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://localhost
HTTP/1.1 308 Permanent Redirect
Connection: close
Location: https://localhost/
Server: Caddy
Date: Thu, 26 Feb 2026 06:54:36 GMT
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost
HTTP/2 200 
alt-svc: h3=":443"; ma=2592000
content-type: text/plain
date: Thu, 26 Feb 2026 06:54:42 GMT
server: WSGIServer/0.2 CPython/3.14.3
via: 1.0 Caddy
content-length: 29

$ curl https://localhost
Hello HTTPS Bottle via Caddy!
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/bottle-caddy_Development_Root_CA.crt` をインポートします
