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
  cfg = config.dotfiles.programs.helix;
in
{
  _file = ./helix.nix;

  options.dotfiles.programs = {
    helix = {
      enable = mkEnableOption "set up helix";

      extraPackages = mkOption {
        default = [
          pkgs.marksman
          pkgs.nil
          pkgs.nixfmt
          pkgs.tombi
        ];
        example = lib.literalExpression ''
          [
            pkgs.yaml-language-server
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
      programs = {
        helix = {
          inherit (cfg) enable;
          defaultEditor = lib.mkDefault true;
        };
      };
    }
    (lib.mkIf cfg.enable {
      home = {
        packages = cfg.extraPackages;
      };
    })
  ];
}
