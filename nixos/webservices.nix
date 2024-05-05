{
  flake.nixosModules.webservices =
    {
      inputs,
      pkgs,
      lib,
      config,
      ...
    }:
    let
      certificate = pkgs.runCommand "self-signed-certs" { buildInputs = [ pkgs.openssl ]; } ''
        mkdir $out

        openssl ecparam -name prime256v1 -genkey -noout -out $out/root.key
        openssl req -new -x509 -key $out/root.key -out $out/root.crt -days 3600 \
          -subj "/CN=Caddy Local Authority - 2024 ECC Root" \
          -addext "keyUsage = keyCertSign, cRLSign" \
          -addext "basicConstraints=critical, CA:true, pathlen:1"

        chmod 0600 $out/root.crt
      '';
    in
    {
      services.dnsmasq = {
        enable = true;

        settings = {
          address = [ "/internal/${config.pigeonf.docker0}" ];
          local = [ "/internal/" ];

          listen-address = lib.lists.unique [
            config.pigeonf.docker0
            "127.0.0.1"
            "::1"
          ];

          domain-needed = true;
        };
      };

      virtualisation.docker.daemon.settings.dns = lib.lists.unique [
        config.pigeonf.docker0
        "8.8.8.8"
        "8.8.4.4"
      ];

      services.caddy = {
        enable = true;
        globalConfig = ''
          pki {
            ca {
              root {
                cert ${certificate}/root.crt
                key ${certificate}/root.key
              }
            }
          }
        '';
      };

      security.pki.certificateFiles = [ "${certificate}/root.crt" ];
    };
}
