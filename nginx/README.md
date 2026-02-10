# nginx-https

ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── certs
│   ├── snakeoil.crt
│   └── snakeoil.key
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

HTTPアクセスの確認

```
$ curl -I http://127.0.0.1/
HTTP/1.1 301 Moved Permanently
Server: nginx/1.28.2
Date: Mon, 09 Feb 2026 15:17:42 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://127.0.0.1/
```

HTTPSアクセスの確認

```
$ curl -Ik https://127.0.0.1/
HTTP/1.1 200 OK
Server: nginx/1.28.2
Date: Mon, 09 Feb 2026 15:17:55 GMT
Content-Type: text/html
Content-Length: 25
Last-Modified: Mon, 09 Feb 2026 15:15:07 GMT
Connection: keep-alive
ETag: "6989f9fb-19"
Accept-Ranges: bytes
```