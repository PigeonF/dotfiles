{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.vscodium;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.vscodium = {
    enable = mkEnableOption "PigeonF VSCodium";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        # Nix IDE
        nil
        nixfmt-rfc-style
        # Typos spell checker
        typos
        # vscode-nushell-lang
        nushell
        # Vale
        vale
        ;
    };
  };
}
