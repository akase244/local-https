# apache-mkcert-https

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
Date: Tue, 10 Feb 2026 01:23:20 GMT
Server: Apache/2.4.66 (Unix) OpenSSL/3.5.4
Location: https://localhost/
Content-Type: text/html; charset=iso-8859-1
```

HTTPSアクセスの確認

```
$ curl -Ik https://127.0.0.1/
HTTP/1.1 200 OK
Date: Tue, 10 Feb 2026 01:23:24 GMT
Server: Apache/2.4.66 (Unix) OpenSSL/3.5.4
Last-Modified: Tue, 10 Feb 2026 00:55:24 GMT
ETag: "21-64a6db5f5b283"
Accept-Ranges: bytes
Content-Length: 33
Content-Type: text/html
```