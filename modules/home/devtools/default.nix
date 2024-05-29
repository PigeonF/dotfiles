{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.devtools;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.devtools = {
    enable = mkEnableOption "PigeonF Developer Tools Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages = builtins.attrValues {
        inherit (pkgs)
          bat
          crane
          diffoci
          diffoscopeMinimal
          dive
          docker-client
          ghq
          gitlab-ci-local
          gnumake
          just
          meson
          openssl
          passt
          pkg-config
          podman
          regctl
          xdg-ninja
          ;

        inherit (inputs.nixos-unstable-small.legacyPackages.${pkgs.system}) buildah;
      };
    };
  };
}
