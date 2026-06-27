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
    (lib.mkIf (cfg.enable && cfg.fastLinker && !cfg.cross) {
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
        apple-darwin-clang =
          arch:
          pkgs.writeShellApplication rec {
            name = "${arch}-apple-darwin-clang";
            runtimeInputs = [ pkgs.llvmPackages.lld ];
            text = ''
              exec -a ${name} ${lib.escapeShellArg (lib.getExe pkgs.llvmPackages.clang-unwrapped)} -fuse-ld=lld --sysroot=${lib.escapeShellArg pkgs.sdk-apple-darwin} "$@"
            '';
          };
        xcrun = pkgs.writeShellApplication {
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

                test "$sdk" = "macosx"

                printf '%s\n' ${lib.escapeShellArg pkgs.sdk-apple-darwin}
            else
                printf 'No action specified\n' >&2
                exit 2
            fi
          '';
        };
        pc-windows-msvc-clang-cl = pkgs.writeShellApplication rec {
          name = "pc-windows-msvc-clang-cl";
          runtimeInputs = [ pkgs.llvmPackages.lld ];
          text = ''
            exec -a ${name} ${lib.escapeShellArg (lib.getExe pkgs.llvmPackages.clang-unwrapped)} -fuse-ld=lld /vctoolsdir:${lib.escapeShellArg "${pkgs.sdk-pc-windows-msvc}/crt"} /winsdkdir:${lib.escapeShellArg "${pkgs.sdk-pc-windows-msvc}/sdk"} "$@"
          '';
        };
        lld-link = pkgs.writeShellApplication {
          name = "lld-link";
          # Needed for link.exe
          runtimeInputs = [ pkgs.llvmPackages.lld ];
          text = ''
            # NOTE(PigeonF): Invoke lld, not lld-link, because rust passes -flavor (need to use "$@" first so -flavor is the first argument)
            exec -a lld ${lib.escapeShellArg (lib.getExe' pkgs.llvmPackages.lld "lld")} "$@" /vctoolsdir:${lib.escapeShellArg "${pkgs.sdk-pc-windows-msvc}/crt"} /winsdkdir:${lib.escapeShellArg "${pkgs.sdk-pc-windows-msvc}/sdk"}
          '';
        };
        llvm-lib = pkgs.writeShellApplication {
          name = "llvm-lib";
          runtimeInputs = [
            pkgs.llvmPackages.bintools-unwrapped
          ];
          text = ''
            exec llvm-lib "$@"
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
                  "aarch64-unknown-linux-gnu" = {
                    linker = lib.getExe pkgs.pkgsCross.aarch64-multiplatform.stdenv.cc;
                  };
                  "x86_64-unknown-linux-gnu" = {
                    linker = lib.getExe pkgs.pkgsCross.gnu64.stdenv.cc;
                  };
                  "aarch64-unknown-linux-musl" = {
                    linker = lib.getExe pkgs.pkgsCross.aarch64-multiplatform.pkgsStatic.stdenv.cc;
                  };
                  "x86_64-unknown-linux-musl" = {
                    linker = lib.getExe pkgs.pkgsCross.gnu64.pkgsStatic.stdenv.cc;
                  };
                  "aarch64-pc-windows-msvc" = {
                    linker = lib.getExe lld-link;
                  };
                  "i686-pc-windows-msvc" = {
                    linker = lib.getExe lld-link;
                  };
                  "x86_64-pc-windows-msvc" = {
                    linker = lib.getExe lld-link;
                  };
                };
              };
            };
          };
        };
        home = {
          packages = [
            pkgs.llvmPackages.bintools-unwrapped
            xcrun
          ];
          sessionVariables = {
            CC_aarch64_apple_darwin =
              config.dotfiles.programs.cargo.settings.target."aarch64-apple-darwin".linker;
            CC_x86_64_apple_darwin =
              config.dotfiles.programs.cargo.settings.target."x86_64-apple-darwin".linker;
            CC_aarch64_unknown_linux_gnu =
              config.dotfiles.programs.cargo.settings.target."aarch64-unknown-linux-gnu".linker;
            CC_x86_64_unknown_linux_gnu =
              config.dotfiles.programs.cargo.settings.target."x86_64-unknown-linux-gnu".linker;
            CC_aarch64_unknown_linux_musl =
              config.dotfiles.programs.cargo.settings.target."aarch64-unknown-linux-musl".linker;
            CC_x86_64_unknown_linux_musl =
              config.dotfiles.programs.cargo.settings.target."x86_64-unknown-linux-musl".linker;
            CC_aarch64_pc_windows_msvc = (lib.getExe pc-windows-msvc-clang-cl);
            CC_x86_64_pc_windows_msvc = (lib.getExe pc-windows-msvc-clang-cl);
            CC_i686_pc_windows_msvc = (lib.getExe pc-windows-msvc-clang-cl);
            AR_aarch64_pc_windows_msvc = (lib.getExe llvm-lib);
            AR_x86_64_pc_windows_msvc = (lib.getExe llvm-lib);
            AR_i686_pc_windows_msvc = (lib.getExe llvm-lib);
          };
        };
      }
    )
  ];
}
