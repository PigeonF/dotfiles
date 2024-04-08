{
  flake.nixosModules.dockerRegistry =
    { pkgs, config, ... }:
    {
      services.dockerRegistry = {
        enable = true;
        package = pkgs.gitlab-container-registry;
        enableDelete = true;
        enableGarbageCollect = true;
      };

      services.caddy.virtualHosts."registry.internal".extraConfig = ''
        tls internal
        reverse_proxy http://${config.services.dockerRegistry.listenAddress}:${toString config.services.dockerRegistry.port}
      '';
    };
}
