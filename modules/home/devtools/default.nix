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
      packages =
        builtins.attrValues {
          inherit (pkgs)
            bat
            buildah
            committed
            corepack
            crane
            d2
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
            nh
            ninja
            nodejs
            openssl
            pkg-config
            podman
            pre-commit
            regctl
            reuse
            scdoc
            tagref
            tealdeer
            typst
            watchman
            xdg-ninja
            yamllint
            zip
            ;
        }
        ++ (lib.lists.optionals pkgs.stdenv.isLinux (
          builtins.attrValues {
            inherit (pkgs)
              bpftrace
              ltrace
              passt
              strace
              valgrind
              ;
          }
        ));
    };
  };
}
