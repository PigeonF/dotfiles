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
    inputs.sops-nix.nixosModules.sops

    ./disko.nix
    ./hardware-configuration.nix
    ./secrets
    ./services
    ./users.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "tatooine";
    domain = "rc4.xyz";
  };

  environment.defaultPackages = lib.mkForce [ ];

  nix = {
    settings = {
      use-xdg-base-directories = true;

      experimental-features = [
        "flakes"
        "nix-command"
      ];

      auto-optimise-store = true;
    };

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  pigeonf = {
    hetzner = {
      wan = {
        enable = true;
        dhcp = true;
        name = "enp1s0";
        addresses = [ "2a01:4f8:c17:cd61::1/64" ];
      };
    };
  };

  system.stateVersion = "24.05";
}
