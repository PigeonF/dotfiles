{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.pigeonf.python;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.python = {
    enable = mkEnableOption "PigeonF Python Packages";
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        let
          nixpkgs-python = inputs.nixpkgs-python.packages.${pkgs.system};
        in
        [
          (pkgs.hiPrio pkgs.gcc)
          (pkgs.hiPrio (
            pkgs.python312.withPackages (ppkgs: builtins.attrValues { inherit (ppkgs) pipx virtualenv; })
          ))
          nixpkgs-python."3.8"
          nixpkgs-python."3.9"
          nixpkgs-python."3.10"
          nixpkgs-python."3.11"
        ];
    };
  };
}
