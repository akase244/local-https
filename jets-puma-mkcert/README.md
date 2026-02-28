# jets-puma-mkcert

- TLS終端: Puma
- webサーバー: Puma
- コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
- ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
- ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します

ディレクトリ構成

```
.
├── Dockerfile
├── Gemfile
├── README.md
├── app
│   └── controllers
│       └── hello_controller.rb
├── certs
│   ├── snakeoil.crt
│   └── snakeoil.key
├── compose.yaml
├── config
│   ├── puma.rb
│   └── routes.rb
└── entrypoint.sh
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

Ruby on Jets(Puma)は9293番ポートでSSL/TLS接続のみを受け付けるためHTTP接続は不可。

```
$ curl -I http://localhost:9293
curl: (52) Empty reply from server
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost:9293
HTTP/1.1 200 OK
content-type: text/plain
vary: Accept
etag: W/"0598f43e489b3ae2d10561ad239ac337"
cache-control: max-age=0, private, must-revalidate
x-request-id: 8c00d777-28a0-4e46-941d-7d62d96393f4
x-runtime: 0.007282
server-timing: start_processing.action_controller;dur=0.02, render_template.action_view;dur=0.05, process_action.action_controller;dur=2.50
content-length: 0

$ curl https://localhost:9293
Hello Jets via Puma
```