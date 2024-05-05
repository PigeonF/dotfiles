{ pkgs, config, ... }:
let
  # Caddy creates the `.crt` file with 0600 permissions, which means it cannot be read when
  # creating a new buildx builder. Instead, we create another self signed cert just for the
  # registry.
  #
  # https://caddy.community/t/certificate-file-permissions-when-sharing-certificates/13211
  certificate =
    pkgs.runCommand "self-signed-certs-docker-registry" { buildInputs = [ pkgs.openssl ]; }
      ''
        mkdir $out

        openssl ecparam -name prime256v1 -genkey -noout -out $out/registry.key
        openssl req -new -x509 -key $out/registry.key -out $out/registry.crt -days 3600 \
          -subj "/CN=Caddy Local Authority - 2024 ECC Registry" \
          -addext "keyUsage = keyCertSign, cRLSign" \
          -addext "basicConstraints=critical, CA:true, pathlen:1" \
          -addext "subjectAltName = DNS:registry.internal"

        chmod 0644 $out/registry.crt
      '';
in
{
  services.dockerRegistry = {
    enable = true;
    package = pkgs.gitlab-container-registry;
    enableDelete = true;
    enableGarbageCollect = true;
  };

  services.caddy.virtualHosts."registry.internal".extraConfig = ''
    tls "${certificate}/registry.crt" "${certificate}/registry.key"

    reverse_proxy http://${config.services.dockerRegistry.listenAddress}:${toString config.services.dockerRegistry.port}
  '';

  environment.etc."docker/certs.d/registry.internal/ca.crt" = {
    source = "${certificate}/registry.crt";
  };

  environment.etc."buildkit/buildkitd.toml" = {
    text = ''
      [registry]

        [registry."registry.internal"]
          ca = ["${certificate}/registry.crt"]
    '';
  };
}
