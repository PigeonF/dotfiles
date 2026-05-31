{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.atuin;
in
{
  _file = ./atuin.nix;

  options.dotfiles.programs = {
    atuin = {
      enable = mkEnableOption "set up atuin";
    };
  };

  config = lib.mkMerge [
    {
      programs.atuin = {
        inherit (cfg) enable;
        flags = [ "--disable-up-arrow" ];
        settings = lib.mkForce { };
      };
    }
  ];
}
