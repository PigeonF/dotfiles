{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.dotfiles.programs.git;
in
{
  _file = ./git.nix;

  options.dotfiles.programs = {
    git = {
      enable = mkEnableOption "set up git";
      package = lib.mkPackageOption pkgs "git" { };
      extraPackages = mkOption {
        default = [
          pkgs.delta
          pkgs.difftastic
          pkgs.git-branchless
        ];
        example = lib.literalExpression ''
          [
            pkgs.git-branchless
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
    (lib.mkIf cfg.enable {
      programs = {
        # Writes to ~/.config/git/config unconditionally, but we want to use our dotfiles instead.
        git.enable = false;
      };
      home = {
        packages = [ cfg.package ];
      };
    })
    (lib.mkIf cfg.enable {
      home = {
        packages = cfg.extraPackages;

        shellAliases = {
          g = "git";
        };
      };
    })
  ];
}
