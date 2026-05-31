{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.nix;
in
{
  _file = ./nix.nix;

  options.dotfiles.programs = {
    nix = {
      enable = mkEnableOption "set up nix";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      nix = {
        package = lib.mkDefault pkgs.nix;
        settings = {
          extra-experimental-features = "flakes nix-command";
          lint-url-literals = "fatal";
          sandbox = true;
          use-xdg-base-directories = true;
        };
      };
    })
  ];
}
