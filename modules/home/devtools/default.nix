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
          committed
          crane
          diffoci
          diffoscopeMinimal
          dive
          docker-client
          editorconfig-checker
          ghq
          gitlab-ci-local
          gitleaks
          gnumake
          go
          just
          markdownlint-cli2
          meson
          nodejs
          openssl
          passt
          pkg-config
          podman
          regctl
          reuse
          xdg-ninja
          yamllint
          ;

        inherit (inputs.nixos-unstable-small.legacyPackages.${pkgs.system}) buildah;
      };
    };
  };
}
