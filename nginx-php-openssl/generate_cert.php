<?php

declare(strict_types=1);

final class TempConfigFile
{
    private readonly string $path;

    public function __construct(string $prefix, string $content)
    {
        $base = tempnam(sys_get_temp_dir(), $prefix);
        if ($base === false) {
            throw new \RuntimeException('Failed to create temp file');
        }
        $this->path = $base . '.cnf';
        file_put_contents($this->path, $content);
    }

    public function path(): string
    {
        return $this->path;
    }

    public function __destruct()
    {
        if (file_exists($this->path)) {
            unlink($this->path);
        }
    }
}

final class CertificateGenerator
{
    private const KEY_BITS = 4096;
    private const CA_VALIDITY_DAYS = 3650;
    private const SERVER_VALIDITY_DAYS = 365;
    private const CA_SERIAL = 1;
    private const SERVER_SERIAL = 2;

    public function __construct(
        private readonly string $certDir,
        private readonly string $rootCaName = 'snakeoil_ca',
        private readonly string $serverCertName = 'snakeoil',
    ) {}

    public function rootCaKeyPath(): string
    {
        return "{$this->certDir}/{$this->rootCaName}.key";
    }

    public function rootCaCrtPath(): string
    {
        return "{$this->certDir}/{$this->rootCaName}.crt";
    }

    public function serverKeyPath(): string
    {
        return "{$this->certDir}/{$this->serverCertName}.key";
    }

    public function serverCrtPath(): string
    {
        return "{$this->certDir}/{$this->serverCertName}.crt";
    }

    public function allCertsExist(): bool
    {
        return file_exists($this->rootCaKeyPath())
            && file_exists($this->rootCaCrtPath())
            && file_exists($this->serverKeyPath())
            && file_exists($this->serverCrtPath());
    }

    public function ensureCertDir(): void
    {
        if (!is_dir($this->certDir)) {
            mkdir($this->certDir, 0755, true);
        }
    }

    public function generateKey(): \OpenSSLAsymmetricKey
    {
        $key = openssl_pkey_new([
            'private_key_bits' => self::KEY_BITS,
            'private_key_type' => OPENSSL_KEYTYPE_RSA,
        ]);

        if ($key === false) {
            throw new \RuntimeException('Failed to generate private key');
        }

        return $key;
    }

    public function buildCaConfig(): string
    {
        return <<<CNF
            [req]
            default_bits = 4096
            prompt = no
            default_md = sha256
            distinguished_name = dn
            x509_extensions = v3_ca

            [dn]
            C = JP
            ST = Tokyo
            L = Chiyoda
            O = Local Development
            CN = localhost

            [v3_ca]
            basicConstraints = critical,CA:TRUE
            keyUsage = critical,digitalSignature,keyCertSign,cRLSign
            subjectKeyIdentifier = hash
            CNF;
    }

    public function buildServerConfig(): string
    {
        return <<<CNF
            [req]
            default_bits = 4096
            prompt = no
            default_md = sha256
            distinguished_name = dn
            req_extensions = v3_req

            [dn]
            C = JP
            ST = Tokyo
            L = Chiyoda
            O = Local Development
            CN = localhost

            [v3_req]
            basicConstraints = critical,CA:FALSE
            subjectAltName = @alt_names
            keyUsage = digitalSignature, keyEncipherment
            extendedKeyUsage = serverAuth

            [v3_server]
            basicConstraints = critical,CA:FALSE
            subjectAltName = @alt_names
            keyUsage = digitalSignature, keyEncipherment
            extendedKeyUsage = serverAuth

            [alt_names]
            DNS.1 = localhost
            IP.1 = 127.0.0.1
            IP.2 = ::1
            CNF;
    }

    public function generateCaCertificate(
        \OpenSSLAsymmetricKey $caKey,
        string $configPath,
    ): \OpenSSLCertificate {
        $dn = [
            'C'  => 'JP',
            'ST' => 'Tokyo',
            'L'  => 'Chiyoda',
            'O'  => 'Local Development',
            'CN' => 'localhost',
        ];

        $csr = openssl_csr_new($dn, $caKey, [
            'config'     => $configPath,
            'digest_alg' => 'sha256',
        ]);

        if ($csr === false) {
            throw new \RuntimeException('Failed to generate CA CSR');
        }

        $cert = openssl_csr_sign($csr, null, $caKey, self::CA_VALIDITY_DAYS, [
            'config'          => $configPath,
            'x509_extensions' => 'v3_ca',
            'digest_alg'      => 'sha256',
        ], self::CA_SERIAL);

        if ($cert === false) {
            throw new \RuntimeException('Failed to generate CA certificate');
        }

        return $cert;
    }

    public function generateServerCsr(
        \OpenSSLAsymmetricKey $serverKey,
        string $configPath,
    ): \OpenSSLCertificateSigningRequest {
        $dn = [
            'C'  => 'JP',
            'ST' => 'Tokyo',
            'L'  => 'Chiyoda',
            'O'  => 'Local Development',
            'CN' => 'localhost',
        ];

        $csr = openssl_csr_new($dn, $serverKey, [
            'config'     => $configPath,
            'digest_alg' => 'sha256',
        ]);

        if ($csr === false) {
            throw new \RuntimeException('Failed to generate server CSR');
        }

        return $csr;
    }

    public function signServerCertificate(
        \OpenSSLCertificateSigningRequest $csr,
        \OpenSSLCertificate $caCert,
        \OpenSSLAsymmetricKey $caKey,
        string $configPath,
    ): \OpenSSLCertificate {
        $cert = openssl_csr_sign($csr, $caCert, $caKey, self::SERVER_VALIDITY_DAYS, [
            'config'          => $configPath,
            'x509_extensions' => 'v3_server',
            'digest_alg'      => 'sha256',
        ], self::SERVER_SERIAL);

        if ($cert === false) {
            throw new \RuntimeException('Failed to sign server certificate');
        }

        return $cert;
    }

    public function saveKey(\OpenSSLAsymmetricKey $key, string $path): void
    {
        if (!openssl_pkey_export_to_file($key, $path)) {
            throw new \RuntimeException("Failed to save key to {$path}");
        }
        chmod($path, 0600);
    }

    public function saveCertificate(\OpenSSLCertificate $cert, string $path): void
    {
        if (!openssl_x509_export_to_file($cert, $path)) {
            throw new \RuntimeException("Failed to save certificate to {$path}");
        }
        chmod($path, 0644);
    }
}

// ---- エントリポイント ----

$generator = new CertificateGenerator('/etc/nginx/certs');

if ($generator->allCertsExist()) {
    echo "certificate already exists\n";
    exit(0);
}

echo "generating certificate...\n";

try {
    $generator->ensureCertDir();

    $caKey        = $generator->generateKey();
    $caConfigFile = new TempConfigFile('ca_openssl_', $generator->buildCaConfig());
    $caCert       = $generator->generateCaCertificate($caKey, $caConfigFile->path());
    $generator->saveKey($caKey, $generator->rootCaKeyPath());
    $generator->saveCertificate($caCert, $generator->rootCaCrtPath());

    $serverKey        = $generator->generateKey();
    $serverConfigFile = new TempConfigFile('server_openssl_', $generator->buildServerConfig());
    $serverCsr        = $generator->generateServerCsr($serverKey, $serverConfigFile->path());
    $serverCert       = $generator->signServerCertificate($serverCsr, $caCert, $caKey, $serverConfigFile->path());
    $generator->saveKey($serverKey, $generator->serverKeyPath());
    $generator->saveCertificate($serverCert, $generator->serverCrtPath());

    echo "certificate generated successfully\n";
    exit(0);
} catch (\RuntimeException $e) {
    fwrite(STDERR, $e->getMessage() . "\n");
    exit(1);
}
