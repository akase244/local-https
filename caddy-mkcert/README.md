# caddy-mkcert-https

```
.
├── Caddyfile
├── Dockerfile
├── README.md
├── certs
│   ├── snakeoil.crt
│   └── snakeoil.key
├── compose.yaml
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

HTTPアクセスの確認

```
$ curl -I http://localhost/
HTTP/1.1 308 Permanent Redirect
Connection: close
Location: https://localhost/
Server: Caddy
Date: Mon, 09 Feb 2026 16:46:26 GMT
```

HTTPSアクセスの確認

```
$ curl -Ik https://localhost/
HTTP/2 200 
accept-ranges: bytes
alt-svc: h3=":443"; ma=2592000
content-type: text/html; charset=utf-8
etag: "dgakhtlslqh7w"
last-modified: Mon, 09 Feb 2026 16:21:43 GMT
server: Caddy
vary: Accept-Encoding
content-length: 32
date: Mon, 09 Feb 2026 16:46:42 GMT
```