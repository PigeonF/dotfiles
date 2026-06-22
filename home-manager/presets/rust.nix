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
      cross = mkEnableOption "enable cross compilers";

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
          pkgs.semgrep
          pkgs.syft
          pkgs.tombi
          pkgs.xwin
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
    (
      let
        macosxsdkversion = "11.3";
        macosxsdk = pkgs.fetchzip {
          url = "https://github.com/phracker/MacOSX-SDKs/releases/download/${macosxsdkversion}/MacOSX${macosxsdkversion}.sdk.tar.xz";
          hash = "sha256-BoFWhRSHaD0j3dzDOFtGJ6DiRrdzMJhkjxztxCluFKo=";
        };
        xcrun-sdks = pkgs.linkFarm "xcrun-sdks" [
          {
            name = "macosxsdk";
            path = macosxsdk;
          }
        ];
        apple-darwin-clang =
          arch:
          pkgs.writeShellApplication {
            name = "${arch}-apple-darwin-clang";
            text = ''
              exec -a clang ${lib.escapeShellArg (lib.getExe pkgs.llvmPackages.clang-unwrapped)} -fuse-ld=lld --ld-path=${lib.escapeShellArg (lib.getExe' pkgs.llvmPackages.lld "ld64.lld")} -target "${arch}-apple-darwin" --sysroot ${lib.escapeShellArg macosxsdk} "$@"
            '';
          };
      in
      lib.mkIf (cfg.enable && cfg.cross) {
        dotfiles = {
          programs = {
            cargo = {
              enable = true;
              settings = {
                target = {
                  "aarch64-apple-darwin" = {
                    linker = lib.getExe (apple-darwin-clang "aarch64");
                  };
                  "x86_64-apple-darwin" = {
                    linker = lib.getExe (apple-darwin-clang "x86_64");
                  };
                };
              };
            };
          };
        };
        home = {
          packages = [
            (pkgs.writeShellApplication {
              name = "xcrun";
              text = ''
                sdk=""
                show=0

                while test -n "''${1:-}"; do
                    case "$1" in
                        '--sdk')
                            sdk="''${2:?Missing required value for argument 'sdk'}"
                            shift
                            ;;
                        '--show-sdk-path')
                            show=1
                            ;;
                        *)
                            printf 'Unknown argument: "%s"\n' "''${1}" >&2
                            exit 1
                            ;;
                    esac

                    shift
                done


                if [ "$show" -eq 1 ]; then
                    if [ -z "$sdk" ]; then
                        printf 'Missing required argument "--sdk"\n' >&2
                        exit 1
                    fi

                    printf '${xcrun-sdks}/%ssdk/\n' "$sdk"
                else
                    printf 'No action specified\n' >&2
                    exit 2
                fi
              '';
            })
          ];
          sessionVariables = {
            CC_aarch64_apple_darwin =
              config.dotfiles.programs.cargo.settings.target."aarch64-apple-darwin".linker;
            CC_x86_64_apple_darwin =
              config.dotfiles.programs.cargo.settings.target."x86_64-apple-darwin".linker;
          };
        };
      }
    )
  ];
}
