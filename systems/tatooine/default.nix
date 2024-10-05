{
  inputs,
  modulesPath,
  lib,
  ...
}:
{
  _file = ./default.nix;

  imports = [
    (modulesPath + "/profiles/headless.nix")
    (modulesPath + "/profiles/minimal.nix")

    inputs.disko.nixosModules.disko
    inputs.self.nixosModules.hetzner

    ./hardware-configuration.nix
    ./disko.nix
    ./users.nix
    ./services
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "tatooine";
  };

  environment.defaultPackages = lib.mkForce [ ];

  pigeonf = {
    hetzner = {
      wan = {
        enable = true;
        dhcp = true;
        name = "enp1s0";
        addresses = [ "2a01:4f8:1c1b:a16c::1/64" ];
      };
    };
  };

  system.stateVersion = "24.05";
}
