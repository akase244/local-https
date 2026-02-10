# nginx-mkcert-https

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

ホストPCで `mkcert` をインストール

```
$ sudo apt install mkcert
```

`libnss3-tools` が必要な場合がありますので、その際は同時にインストールします

```
$ sudo apt install mkcert libnss3-tools
```

ローカルCA証明書を作成

```
$ mkcert -install
Created a new local CA 💥
The local CA is now installed in the system trust store! ⚡️
The local CA is now installed in the Firefox and/or Chrome/Chromium trust store (requires browser restart)! 🦊
```

CAROOT のディレクトリを確認

```
$ mkcert -CAROOT
/home/akase244/.local/share/mkcert
```

作成されたローカルCA証明書を確認

```
$ ls -l `mkcert -CAROOT`/*.pem
-r-------- 1 akase244 akase244 2484  2月 10 11:04 /home/akase244/.local/share/mkcert/rootCA-key.pem
-rw-r--r-- 1 akase244 akase244 1716  2月 10 11:04 /home/akase244/.local/share/mkcert/rootCA.pem
```

ホストPCの CAROOT のパスと `compose.yaml` の以下の箇所が一致している必要があります

```
- ~/.local/share/mkcert:/mkcert:ro
```

上記の指定によりブラウザでアクセスした際に「この接続ではプライバシーが保護されません」といった警告が表示されなくなります

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
Date: Mon, 09 Feb 2026 15:19:37 GMT
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
Date: Mon, 09 Feb 2026 15:20:00 GMT
Content-Type: text/html
Content-Length: 32
Last-Modified: Mon, 09 Feb 2026 15:15:18 GMT
Connection: keep-alive
ETag: "6989fa06-20"
Accept-Ranges: bytes
```