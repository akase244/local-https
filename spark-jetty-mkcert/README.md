# spark-jetty-mkcert

- TLS終端: Jetty
- webサーバー: Jetty
- コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
- ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
- ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します

ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── certs
├── compose.yaml
├── entrypoint.sh
├── pom.xml
└── src
    └── main
        └── java
            └── App.java
```

ホストPCで `mkcert` をインストール

```
$ sudo apt install mkcert
```

ルート証明書を作成

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

作成されたルート証明書を確認

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

Jettyは4567番ポートでSSL/TLS接続のみを受け付けるためHTTP接続は不可。

```
$ curl -I http://localhost:4567
curl: (1) Received HTTP/0.9 when not allowed
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost:4567
HTTP/1.1 200 OK
Date: Thu, 26 Feb 2026 05:00:51 GMT
Content-Type: text/html;charset=utf-8
Transfer-Encoding: chunked
Server: Jetty(9.4.56.v20240826)
```