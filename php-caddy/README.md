# php-caddy

- TLS終端: Caddy 
- webサーバー: PHPのビルトインサーバー
- コンテナ内で `Caddy` によりルート証明書とサーバー証明書を発行します
- コンテナ内の `Caddy` で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します

ディレクトリ構成

```
$ tree 
.
├── Caddyfile
├── Dockerfile
├── README.md
├── certs
│   └── php-caddy_Development_Root_CA.crt
├── compose.yaml
├── entrypoint.sh
└── public
    └── index.php
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
cat /data/caddy/pki/authorities/local/root.crt > certs/php-caddy_Development_Root_CA.crt
```

Caddyで作成されたルート証明書をホストPCに登録

```
$ sudo cp certs/php-caddy_Development_Root_CA.crt /usr/local/share/ca-certificates/
$ ls -l /usr/local/share/ca-certificates/php-caddy_Development_Root_CA.crt 
-rw-r--r-- 1 root root 631  2月 10 20:53 /usr/local/share/ca-certificates/php-caddy_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://localhost
HTTP/1.1 308 Permanent Redirect
Connection: close
Location: https://localhost/
Server: Caddy
Date: Thu, 26 Feb 2026 03:14:39 GMT
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost
HTTP/2 200 
alt-svc: h3=":443"; ma=2592000
content-type: text/html; charset=UTF-8
date: Thu, 26 Feb 2026 03:16:21 GMT
host: localhost
via: 1.1 Caddy
x-powered-by: PHP/8.5.3
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/php-caddy_Development_Root_CA.crt` をインポートします
