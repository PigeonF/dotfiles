{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.pigeonf.virtualisation.containers.registries;
  inherit (lib) mkOption;
  toml = pkgs.formats.toml { };
in
{
  options = {
    # https://github.com/NixOS/nixpkgs/issues/280288
    pigeonf.virtualisation.containers.registries = {
      settings = mkOption {
        inherit (toml) type;
        default = { };
        description = "registries.conf configuration";
      };
    };
  };

  config = {
    environment.etc = {
      "containers/registries.conf".source = lib.mkForce (toml.generate "registries.conf" cfg.settings);
    };
  };
}