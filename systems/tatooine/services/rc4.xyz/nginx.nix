{
  config,
  inputs,
  lib,
  ...
}:

{
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    appendHttpConfig =
      let
        fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
        realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
      in
      ''
        map $scheme $hsts_header {
            https "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;
        add_header 'Referrer-Policy' 'origin-when-cross-origin';
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
        real_ip_header CF-Connecting-IP;
        ${realIpsFromList (fileToList inputs.cloudflare-ipv6s)}
      '';

    defaultListenAddresses = [ "[::0]" ];

    virtualHosts = {
      "localhost" = {
        default = true;

        locations."/" = {
          return = "444";
        };
      };

      "${config.networking.domain}" = {
        forceSSL = true;
        useACMEHost = "${config.networking.domain}";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
