# apache-https

```
.
├── Dockerfile
├── README.md
├── certs
│   ├── snakeoil.crt
│   └── snakeoil.key
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

HTTPアクセスの確認

```
$ curl -I http://127.0.0.1/
HTTP/1.1 301 Moved Permanently
Date: Mon, 09 Feb 2026 15:15:57 GMT
Server: Apache/2.4.66 (Unix) OpenSSL/3.5.4
Location: https://localhost/
Content-Type: text/html; charset=iso-8859-1
```

HTTPSアクセスの確認

```
$ curl -Ik https://127.0.0.1/
HTTP/1.1 200 OK
Date: Mon, 09 Feb 2026 15:16:29 GMT
Server: Apache/2.4.66 (Unix) OpenSSL/3.5.4
Last-Modified: Mon, 09 Feb 2026 15:14:52 GMT
ETag: "1a-64a6599cb58b8"
Accept-Ranges: bytes
Content-Length: 26
Content-Type: text/html
```