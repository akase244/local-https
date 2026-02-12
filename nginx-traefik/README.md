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

今回 `Traefik` では80番で待ち受ける設定をおこなっていないため 404が返ってきます

```
$ curl -I http://127.0.0.1/
HTTP/1.1 404 Not Found
Content-Type: text/plain; charset=utf-8
X-Content-Type-Options: nosniff
Date: Thu, 12 Feb 2026 05:17:56 GMT
Content-Length: 19
```

HTTPSアクセスの確認

`127.0.0.1` ではアクセスできないようです

```
$ curl -Ik https://localhost/
HTTP/2 200 
accept-ranges: bytes
content-type: text/html
date: Thu, 12 Feb 2026 05:23:05 GMT
etag: "698d59ae-1b"
last-modified: Thu, 12 Feb 2026 04:40:14 GMT
server: nginx/1.29.5
content-length: 27
```
