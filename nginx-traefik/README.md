# nginx-traefik

- コンテナ内で `Traefik` により自己署名のサーバー証明書（兼 ルート証明書）を発行します
- コンテナ内の `Traefik` で作成された自己署名のサーバー証明書はメモリ上に展開されているようです
- SANの値が設定されていない仮の証明書のためコンテナから取り出すことができても警告の抑制を行うことはできません

ディレクトリ構成

```
.
├── README.md
├── certs
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

HTTPアクセスの確認

`127.0.0.1` ではアクセスできません

```
$ curl -I http://localhost/
HTTP/1.1 200 OK
Accept-Ranges: bytes
Content-Length: 27
Content-Type: text/html
Date: Sat, 21 Feb 2026 09:58:32 GMT
Etag: "698d65bd-1b"
Last-Modified: Thu, 12 Feb 2026 05:31:41 GMT
Server: nginx/1.29.5
```

HTTPSアクセスの確認

`127.0.0.1` ではアクセスできません

```
$ curl -Ik https://localhost/
HTTP/2 200 
accept-ranges: bytes
content-type: text/html
date: Sat, 21 Feb 2026 10:01:15 GMT
etag: "698d65bd-1b"
last-modified: Thu, 12 Feb 2026 05:31:41 GMT
server: nginx/1.29.5
content-length: 27
```
