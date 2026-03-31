# nginx-php-openssl

- TLS終端: Nginx
- webサーバー: Nginx
- コンテナ内で PHP の `openssl_*` 関数を利用してルート証明書とサーバー証明書を発行します
- コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します

## 概要

PHP に組み込みの `openssl_*` 関数（`openssl_pkey_new`, `openssl_csr_new`, `openssl_csr_sign`, `openssl_x509_export_to_file`, `openssl_pkey_export_to_file`）のみを使用して、ルート CA 証明書とサーバー証明書（SAN付き）を生成します。

外部コマンド（`openssl` CLI）やサードパーティライブラリは使用しません。

## コンテナ構成

| コンテナ | イメージ | 役割 |
|---|---|---|
| `php-openssl` | `php:8-cli-alpine` | PHP の `openssl_*` 関数で証明書を生成して終了 |
| `web-server` | `nginx:alpine` | 生成された証明書を使用して HTTPS を提供 |

`web-server` は `php-openssl` が正常終了（exit 0）してから起動します（`condition: service_completed_successfully`）。

ディレクトリ構成

```
.
├── Dockerfile
├── README.md
├── certs
│   ├── snakeoil.crt
│   ├── snakeoil.key
│   ├── snakeoil_Development_Root_CA.crt
│   └── snakeoil_Development_Root_CA.key
├── compose.yaml
├── default.conf
├── generate_cert.php
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

Dockerコンテナ内で作成されたルート証明書をホストPCに登録

```
$ sudo cp certs/snakeoil_Development_Root_CA.crt /usr/local/share/ca-certificates/nginx-php-openssl_snakeoil_Development_Root_CA.crt
$ ls -l /usr/local/share/ca-certificates/nginx-php-openssl_snakeoil_Development_Root_CA.crt
$ sudo update-ca-certificates
```

HTTPアクセスの確認

```
$ curl -I http://localhost/
HTTP/1.1 301 Moved Permanently
Server: nginx/1.29.5
Date: Tue, 31 Mar 2026 08:43:54 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://localhost/
```

HTTPSアクセスの確認（「-k」、「--insecure」の指定は不要です）

```
$ curl -I https://localhost/
HTTP/1.1 200 OK
Server: nginx/1.29.5
Date: Tue, 31 Mar 2026 08:44:19 GMT
Content-Type: text/html
Content-Length: 31
Last-Modified: Mon, 30 Mar 2026 14:51:19 GMT
Connection: keep-alive
ETag: "69ca8de7-1f"
Accept-Ranges: bytes
```

Google Chromeで「この接続ではプライバシーが保護されません」といった警告が出ないようにするには以下の操作を行います

Google Chromeで `chrome://settings/certificates` にアクセスします

「ローカル証明書」→「カスタム」→「自分でインストール」→「信頼できる証明書」から `certs/snakeoil_Development_Root_CA.crt` をインポートします
