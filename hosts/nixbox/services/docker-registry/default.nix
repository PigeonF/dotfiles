{
  config,
  pkgs,
  ...
}: {
  services.dockerRegistry = {
    enable = true;
    package = pkgs.gitlab-container-registry;
    enableDelete = true;
    enableGarbageCollect = true;
  };

  sops.secrets."dockerRegistry/certificateKey" = {
    sopsFile = ./local-registry.gitlab.com/key.pem.age;
    format = "binary";
    restartUnits = ["nginx.service"];
    mode = "0440";
    owner = config.services.nginx.user;
    group = config.services.nginx.group;
  };

  security.pki.certificateFiles = [./minica.pem];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."local-registry.gitlab.com" = {
      forceSSL = true;
      # nix run nixpkgs#minica -- --domains local-registry.gitlab.com -ip-addresses 172.17.0.1
      sslCertificate = ./local-registry.gitlab.com/cert.pem;
      sslCertificateKey = "/run/secrets/dockerRegistry/certificateKey";

      listenAddresses = [
        # docker0 ip address
        "172.17.0.1"
      ];

      locations."/".proxyPass = "http://${config.services.dockerRegistry.listenAddress}:${toString config.services.dockerRegistry.port}";
    };
  };

  networking.extraHosts = ''
    172.17.0.1 local-registry.gitlab.com
  '';
}
