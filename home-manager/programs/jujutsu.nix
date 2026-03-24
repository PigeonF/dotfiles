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
    mkPackageOption
    types
    ;
  cfg = config.dotfiles.programs.jujutsu;
in
{
  _file = ./jujutsu.nix;

  options.dotfiles.programs = {
    jujutsu = {
      enable = mkEnableOption "set up jujutsu";
      package = mkPackageOption pkgs.unstablePackages "jujutsu" { };

      extraPackages = mkOption {
        default = [
          pkgs.delta
          pkgs.difftastic
          pkgs.git
          pkgs.mergiraf
          pkgs.watchman
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
        inherit (cfg) enable package;
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
