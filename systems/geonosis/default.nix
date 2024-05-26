{ config, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    inputs.self.nixosModules.default
    inputs.quadlet-nix.nixosModules.quadlet
    inputs.sops-nix.nixosModules.sops

    ./hardware.nix
    ./secrets
  ];

  networking.hostName = "geonosis";

  pigeonf = {
    container-registry.enable = true;
    core.enable = true;
    dns.enable = true;
    nix.enable = true;
    podman.enable = true;
    userAccount.enable = true;

    network = {
      enable = true;
      envFile = config.sops.secrets."network".path;

      networks = {
        obi-lan-kenobi.enable = true;
      };
    };

    gitlabRunner = {
      enable = false;
      runners = {
        default = {
          description = "Default Runner";
          envFile = config.sops.secrets."gitlab-runner/environment".path;
        };

        buildah = {
          description = "Buildah Enabled Runner";
          envFile = config.sops.secrets."gitlab-runner/buildah/environment".path;
          buildahEnabled = true;
        };
      };
    };
  };
}
