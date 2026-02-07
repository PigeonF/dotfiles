{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkPackageOption
    mkOption
    ;
  cfg = config.dotfiles.programs.cargo;
  tomlFormat = pkgs.formats.toml { };
in
{
  _file = ./cargo.nix;

  options.dotfiles.programs = {
    cargo = {
      enable = mkEnableOption "set up cargo";
      package = mkPackageOption pkgs "cargo" { };
      settings = mkOption {
        inherit (tomlFormat) type;
        default = { };
        example = literalExpression ''
          {
            alias = {
              t = "nextest run";
            };
          }
        '';
        description = ''
          Configuration written to {file}`$XDG_DATA_HOME/cargo/config.toml`.
          See <https://doc.rust-lang.org/cargo/reference/config.html> for the documentation.
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = lib.optional (!config.dotfiles.programs.rustup.enable) [ cfg.package ];
      };
    })
    (lib.mkIf cfg.enable {
      assertions = lib.optional (config.programs ? cargo) [
        {
          assertion = !config.programs.cargo.enable;
          # Builtin home manager options do not follow XDG_DATA_HOME
          message = "Do not use the builtin cargo program options";
        }
      ];
      home = {
        sessionPath = [ "$CARGO_HOME/bin" ];
        sessionVariables = {
          CARGO_HOME = "${config.xdg.dataHome}/cargo";
        };
        shellAliases = {
          "c" = "cargo";
        };
      };

      xdg.dataFile = {
        "cargo/config.toml" = lib.mkIf (cfg.settings != { }) {
          source = tomlFormat.generate "cargo-config" cfg.settings;
        };
      };
    })
  ];
}
