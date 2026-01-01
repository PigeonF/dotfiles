{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    ;
  cfg = config.dotfiles.presets.rust;
  systemToRustPlatform =
    system:
    if system == "aarch64-darwin" then
      "aarch64-apple-darwin"
    else if system == "aarch64-linux" then
      "aarch64-unknown-linux-gnu"
    else if system == "x86_64-darwin" then
      "x86_64-apple-darwin"
    else if system == "x86_64-linux" then
      "x86_64-unknown-linux-gnu"
    else
      abort "Cannot convert ${system} to rust platform";
in
{
  _file = ./rust.nix;

  options.dotfiles.presets = {
    rust = {
      enable = mkEnableOption "set up rust development";

      sccache = {
        enable = mkEnableOption "integrate cargo with sccache" // {
          default = true;
        };
        cacheSize = mkOption {
          type = lib.types.ints.positive;
          default = 1024 * 1024 * 1024 * 64;
          description = "Size of the local disk cache";
        };
      };

      fastLinker = mkEnableOption "use a faster linker" // {
        default = pkgs.stdenv.hostPlatform.isLinux;
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      dotfiles = {
        programs = {
          cargo = {
            enable = true;
            settings = {
              alias = {
                t = "nextest run";
              };
            };
          };
          rustup = {
            enable = true;
          };
        };
      };
      home = {
        packages = [
          pkgs.cargo-audit
          pkgs.cargo-auditable
          pkgs.cargo-binstall
          pkgs.cargo-bloat
          pkgs.cargo-crev
          pkgs.cargo-criterion
          pkgs.cargo-cyclonedx
          pkgs.cargo-deduplicate-warnings
          pkgs.cargo-deny
          pkgs.cargo-dist
          pkgs.cargo-flamegraph
          pkgs.cargo-fuzz
          pkgs.cargo-hack
          pkgs.cargo-insta
          pkgs.cargo-llvm-cov
          pkgs.cargo-mutants
          pkgs.cargo-nextest
          pkgs.cargo-release
          pkgs.cargo-semver-checks
          pkgs.cargo-show-asm
          pkgs.cargo-vet
          pkgs.cargo-xwin
          pkgs.cargo-zigbuild
          pkgs.clippy-sarif
          pkgs.git-cliff
          pkgs.just
          pkgs.lldb
          pkgs.sarif-fmt
          pkgs.tombi
        ]
        ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.rr;
      };
    })
    (lib.mkIf (cfg.enable && cfg.fastLinker) {
      dotfiles = {
        programs = {
          cargo = {
            enable = true;
            settings = {
              target = {
                "${systemToRustPlatform pkgs.stdenv.hostPlatform.system}" = {
                  linker = "${lib.getExe pkgs.clang}";
                  rustflags = [
                    "-C"
                    "link-arg=--ld-path=${lib.getExe pkgs.mold}"
                  ];
                };
              };
            };
          };
        };
      };

      home = {
        packages = [
          pkgs.clang
          pkgs.mold
        ];
      };
    })
    (lib.mkIf (cfg.enable && cfg.sccache.enable) {
      dotfiles = {
        programs = {
          cargo = {
            enable = true;
            settings = {
              build = {
                rustc-wrapper = lib.getExe config.dotfiles.programs.sccache.package;
              };
            };
          };
          sccache = {
            enable = true;
            settings = {
              cache = {
                disk = {
                  size = cfg.sccache.cacheSize;
                };
              };
            };
          };
        };
      };
    })
  ];
}
