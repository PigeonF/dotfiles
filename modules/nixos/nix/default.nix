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
        ];

        auto-optimise-store = mkDefault true;

        substituters = [
          "https://cache.nixos.org"
          "https://cachix.cachix.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      # Make flake nixpkgs available
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
      ];

      registry = {
        nixpkgs.flake = mkDefault inputs.nixpkgs;
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
