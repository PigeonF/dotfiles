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
      inherit (inputs.nixpkgs-networking.lib) ipv4;
      listenAddress =
        if config.virtualisation.docker.enable then
          if config.virtualisation.docker.daemon.settings ? bip then
            ipv4.prettyIp (ipv4.cidrToFirstUsableIp config.virtualisation.docker.daemon.settings.bip)
          else
            "172.17.0.1"
        else
          "127.0.0.1";
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
      # Enable dnsmasq, which forwards and listens on .localhost to (127.0.0.1 or docker0)
      # Enable caddy

      services.dnsmasq = {
        enable = true;

        settings = {
          address = [ "/internal/${listenAddress}" ];
          local = [ "/internal/" ];

          listen-address = lib.lists.unique [
            "${listenAddress}"
            "127.0.0.1"
            "::1"
          ];

          domain-needed = true;
        };
      };

      virtualisation.docker.daemon.settings.dns = [
        listenAddress
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

        virtualHosts."hello.internal".extraConfig = ''
          tls internal
          respond "Hello, world!"
        '';
      };

      security.pki.certificateFiles = [ "${certificate}/root.crt" ];
    };
}
