{ config, pkgs, ... }:
let
  # TODO(PigeonF): Find out if we can resolve docker0 using nix
  docker0IpAddress = "10.117.0.1";
in
{
  services.dockerRegistry = {
    enable = true;
    package = pkgs.gitlab-container-registry;
    enableDelete = true;
    enableGarbageCollect = true;
  };

  sops.secrets."dockerRegistry/certificateKey" = {
    sopsFile = ./local-registry.gitlab.com/key.pem.age;
    format = "binary";
    restartUnits = [ "nginx.service" ];
    mode = "0440";

    owner = config.services.nginx.user;
    inherit (config.services.nginx) group;
  };

  security.pki.certificateFiles = [ ./minica.pem ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # https://stackoverflow.com/a/40593944
    clientMaxBodySize = "0";

    virtualHosts."local-registry.gitlab.com" = {
      default = true;
      forceSSL = true;
      # nix run nixpkgs#minica -- --domains local-registry.gitlab.com -ip-addresses 10.117.0.1
      sslCertificate = ./local-registry.gitlab.com/cert.pem;
      sslCertificateKey = "/run/secrets/dockerRegistry/certificateKey";

      listen = [
        {
          addr = docker0IpAddress;
          port = 443;
          ssl = true;
        }
        {
          addr = docker0IpAddress;
          port = 80;
        }
      ];

      locations."/".proxyPass = "http://${config.services.dockerRegistry.listenAddress}:${toString config.services.dockerRegistry.port}";
    };
  };

  networking.extraHosts = ''
    ${docker0IpAddress} local-registry.gitlab.com
  '';
}
