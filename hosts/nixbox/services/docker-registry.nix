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

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts."local-registry.gitlab.com" = {
      listenAddresses = [
        "127.0.0.1"
        # docker0 ip address
        "172.17.0.1"
        "[::1]"
      ];

      locations."/".proxyPass = "http://${config.services.dockerRegistry.listenAddress}:${toString config.services.dockerRegistry.port}";
    };
  };

  networking.extraHosts = ''
    127.0.0.1 local-registry.gitlab.com
  '';
}
