{
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
          bpftrace
          buildah
          committed
          corepack
          crane
          diffedit3
          diffoci
          diffoscopeMinimal
          dive
          docker-client
          editorconfig-checker
          ghq
          git-cliff
          gitlab-ci-local
          gitleaks
          gnumake
          go
          go-task
          grype
          jujutsu
          just
          markdownlint-cli2
          mdbook
          meson
          miller
          ninja
          nodejs
          openssl
          passt
          pkg-config
          podman
          pre-commit
          regctl
          reuse
          tagref
          tealdeer
          typst-dev
          valgrind
          xdg-ninja
          yamllint
          ;
      };
    };
  };
}
