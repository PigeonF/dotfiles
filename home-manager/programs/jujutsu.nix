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
    types
    ;
  cfg = config.dotfiles.programs.jujutsu;
in
{
  _file = ./jujutsu.nix;

  options.dotfiles.programs = {
    jujutsu = {
      enable = mkEnableOption "set up jujutsu";

      extraPackages = mkOption {
        default = [
          pkgs.git
          pkgs.watchman
          pkgs.delta
        ];
        example = lib.literalExpression ''
          [
            pkgs.watchman
          ]
        '';
        type = types.listOf types.package;
        description = ''
          Extra packages that should be installed to the home profile.
        '';
      };
    };
  };

  config = lib.mkMerge [
    {
      programs.jujutsu = {
        inherit (cfg) enable;
      };
    }
    (lib.mkIf cfg.enable {
      home = {
        packages = cfg.extraPackages;

        shellAliases = {
          jjj = "jj --ignore-working-copy";
        };
      };
    })
  ];
}
