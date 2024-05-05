{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.docker-client
    pkgs.docker-compose
  ];

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      # dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
