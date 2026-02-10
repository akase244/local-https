# apache-mkcert-https

ディレクトリ構成

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

ホストPCで `mkcert` をインストール

```
$ sudo apt install mkcert
```

Firefox を利用する場合は追加で `libnss3-tools` のインストールが必要な場合があるようです

```
$ sudo apt install libnss3-tools
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

`mkcert -install` を実行することで `mkcert -CAROOT`/rootCA.pem と同じ内容のファイルが以下のパスにコピーされます

```
$ ls -l /usr/local/share/ca-certificates/*.crt
-rw-r--r-- 1 root root 1716  2月 10 11:04 /usr/local/share/ca-certificates/mkcert_development_CA_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.crt
```

同じ内容のため差分は何も表示されません

```
$ diff `mkcert -CAROOT`/rootCA.pem /usr/local/share/ca-certificates/mkcert_development_CA_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.crt
（何も表示されない）
```

また、以下のパスにシンボリックリンクが作成され各アプリケーションから参照されます

```
$ ls -l /etc/ssl/certs/mkcert_*.pem 
lrwxrwxrwx 1 root root 97  2月 10 11:04 /etc/ssl/certs/mkcert_development_CA_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.pem -> /usr/local/share/ca-certificates/mkcert_development_CA_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.crt
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
Date: Tue, 10 Feb 2026 03:22:00 GMT
Server: Apache/2.4.66 (Unix) OpenSSL/3.5.4
Location: https://localhost/
Content-Type: text/html; charset=iso-8859-1
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://127.0.0.1/
HTTP/1.1 200 OK
Date: Tue, 10 Feb 2026 03:22:14 GMT
Server: Apache/2.4.66 (Unix) OpenSSL/3.5.4
Last-Modified: Tue, 10 Feb 2026 01:35:32 GMT
ETag: "21-64a6e4576f168"
Accept-Ranges: bytes
Content-Length: 33
Content-Type: text/html
```