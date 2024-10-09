{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.pigeonf.nix;
  inherit (lib) mkDefault;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.nix = {
      enable = lib.mkEnableOption "default nix configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        sandbox = mkDefault true;
        use-xdg-base-directories = mkDefault true;

        experimental-features = [
          "auto-allocate-uids"
          "flakes"
          "nix-command"
          "repl-flake"
        ];

        auto-optimise-store = mkDefault true;

        substituters = [
          "https://cache.nixos.org"
          "https://cachix.cachix.org"
          "https://nix-community.cachix.org"
          "https://nixpkgs-python.cachix.org"
        ];

        trusted-public-keys = [
          "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
        ];
      };

      # Make flake nixpkgs available
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
        "nixos-unstable-small=${inputs.nixos-unstable-small}"
      ];

      registry = {
        nixpkgs.flake = mkDefault inputs.nixpkgs;
        nixos-unstable-small.flake = mkDefault inputs.nixos-unstable-small;
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = mkDefault true;
      };
    };

    systemd.services.nix-daemon = {
      environment.TMPDIR = "/var/tmp";
    };
  };
}
