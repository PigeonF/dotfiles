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
  cfg = config.dotfiles.programs.sccache;
  tomlFormat = pkgs.formats.toml { };
in
{
  _file = ./sccache.nix;

  options.dotfiles.programs = {
    sccache = {
      enable = mkEnableOption "set up sccache";
      package = mkPackageOption pkgs "sccache" { };
      settings = mkOption {
        inherit (tomlFormat) type;
        default = { };
        example = literalExpression ''
          {
            dist = {
              scheduler_url = "http://1.2.3.4:10600";
            };
          }
        '';
        description = ''
          Configuration written to {file}`$XDG_DATA_HOME/sccache/config`.
          See <https://github.com/mozilla/sccache/blob/main/docs/Configuration.md> for the documentation.
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home = {
        packages = [ cfg.package ];
      };
    })
    (lib.mkIf cfg.enable {
      xdg.configFile = {
        "sccache/config" = lib.mkIf (cfg.settings != { }) {
          source = tomlFormat.generate "sccache-config" cfg.settings;
        };
      };
    })
  ];
}
