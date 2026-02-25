# local-https

Dockerコンテナを利用してローカルでHTTPS接続が可能な環境を提供できるかを調査するためのリポジトリです

```
.
├── apache-ca-false
│   ├── TLS終端: Apache
│   ├── webサーバー: Apache
│   ├── コンテナ内で `openssl` コマンドを利用してルート証明書とサーバー証明書を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── apache-ca-true
│   ├── TLS終端: Apache
│   ├── webサーバー: Apache
│   ├── コンテナ内で `openssl` コマンドを利用してルート証明書（「basicConstraints=CA:TRUE」付きのサーバー証明書）を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── apache-mkcert
│   ├── TLS終端: Apache
│   ├── webサーバー: Apache
│   ├── コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
│   ├── ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
│   └── ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します
├── apache-nginx-ca-true
│   ├── TLS終端: Nginx
│   ├── webサーバー: Apache
│   ├── コンテナ内で `openssl` コマンドを利用してルート証明書（「basicConstraints=CA:TRUE」付きのサーバー証明書）を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── caddy
│   ├── TLS終端: Caddy
│   ├── webサーバー: Caddy
│   ├── コンテナ内で `Caddy` によりルート証明書とサーバー証明書を発行します
│   └── コンテナ内の `Caddy` で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── caddy-mkcert
│   ├── TLS終端: Caddy
│   ├── webサーバー: Caddy
│   ├── コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
│   ├── ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
│   └── ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します
├── flask-mkcert
│   ├── TLS終端: Flask
│   ├── webサーバー: Flask
│   ├── コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
│   ├── ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
│   └── ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します
├── nginx-ca-false
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `openssl` コマンドを利用してルート証明書とサーバー証明書を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── nginx-ca-true
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `openssl` コマンドを利用してルート証明書（「basicConstraints=CA:TRUE」付きのサーバー証明書）を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── nginx-caddy
│   ├── TLS終端: Caddy 
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `Caddy` によりルート証明書とサーバー証明書を発行します
│   └── コンテナ内の `Caddy` で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── nginx-caddy-mkcert
│   ├── TLS終端: Caddy 
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
│   ├── ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
│   └── ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します
├── nginx-certstrap
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `certstrap` コマンドを利用してルート証明書とサーバー証明書を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── nginx-cfssl
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `cfssl gencert` コマンドを利用してルート証明書とサーバー証明書を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── nginx-easy-rsa
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `easyrsa` コマンドを利用してルート証明書とサーバー証明書を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── nginx-minica
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `minica` コマンドを利用してルート証明書とサーバー証明書を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── nginx-mkcert
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
│   ├── ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
│   └── ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します
├── nginx-step-ca
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `step certificate create` コマンドを利用してルート証明書とサーバー証明書を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── nginx-traefik
│   ├── TLS終端: Traefik
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `Traefik` により自己署名のサーバー証明書（兼 ルート証明書）を発行します
│   ├── コンテナ内の `Traefik` で作成された自己署名のサーバー証明書はメモリ上に展開されているようです
│   └── SANの値が設定されていない仮の証明書のためコンテナから取り出すことができても警告の抑制を行うことはできません
├── nginx-traefik-mkcert
│   ├── TLS終端: Traefik
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
│   ├── ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
│   └── ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します
├── nginx-vault
│   ├── TLS終端: Nginx
│   ├── webサーバー: Nginx
│   ├── コンテナ内で `vault` コマンドを利用してルート証明書とサーバー証明書を発行します
│   └── コンテナ内で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
├── rails-puma-mkcert
│   ├── TLS終端: Puma
│   ├── webサーバー: Puma
│   ├── コンテナ内で `mkcert` コマンドを利用してサーバー証明書を発行します
│   ├── ホストPC内で `mkcert` コマンドを利用してルート証明書を発行します
│   └── ホストPCの `mkcert` コマンドで作成したルート証明書を登録することでサーバー証明書の警告を抑制します
└── sinatra-unicorn-caddy
    ├── TLS終端: Caddy
    ├── webサーバー: Uniconn
    ├── コンテナ内で `Caddy` によりルート証明書とサーバー証明書を発行します
    └── コンテナ内の `Caddy` で作成されたルート証明書をホストPCに登録することでサーバー証明書の警告を抑制します
```

- 証明書発行のために利用したツール群
  - [OpenSSL](https://www.openssl.org/)
  - [mkcert](https://mkcert.org/)
  - [Caddy](https://caddyserver.com/)
  - [certstrap (Square)](https://github.com/square/certstrap)
  - [CFSSL (Cloudflare)](https://github.com/cloudflare/cfssl)
  - [easy-rsa (OpenVPN)](https://github.com/OpenVPN/easy-rsa)
  - [Step CLI (Smallstep)](https://github.com/smallstep/cli)
  - [Traefik (Traefik Labs)](https://traefik.io/traefik)
  - [Minica](https://github.com/jsha/minica)
  - [Vault (HashiCorp)](https://www.hashicorp.com/ja/products/vault)

- webサーバー/リバースプロキシとして利用したツール群
  - [Caddy](https://caddyserver.com/)
  - [Traefik (Traefik Labs)](https://traefik.io/traefik)
  - [Puma](https://puma.io/)
  - [Unicorn](https://yhbt.net/unicorn/README.html)
  - [Apache](https://httpd.apache.org/)
  - [Nginx](https://nginx.org/en/)
  - [Flask](https://flask.palletsprojects.com/en/stable/)

- ブラウザでサーバー証明書の警告を抑制するには
    - 発行したルート証明書 または サーバー証明書をブラウザでインポートする
- curlコマンド等でサーバー証明書の警告を抑制するには
    - 発行したルート証明書を System Trust Store(update-ca-certificates) に登録する(Linux)
    - 発行したルート証明書を キーチェーン に登録する(macOS)
    - 発行したルート証明書を Windows証明書ストア に登録する(Windows)
