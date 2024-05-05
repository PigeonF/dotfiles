{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.docker-client
    pkgs.docker-compose
  ];

  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      # https://github.com/NixOS/nixpkgs/issues/306398
      # https://github.com/containers/podman/issues/22561
      package = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.podman;
      # dockerCompat = true;
      dockerSocket.enable = true;
      # defaultNetwork.settings = {
      #   dns_enabled = true;
      #   subnets = [
      #     {
      #       gateway = "10.117.0.1";
      #       subnet = "10.117.0.0/16";
      #     }
      #   ];
      # };
    };

    oci-containers.backend = "podman";
  };
  # networking.firewall.trustedInterfaces = [ "podman0" ];
}
