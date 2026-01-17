
{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.docker;
in
{
  _file = ./docker.nix;

  options.dotfiles.programs = {
    docker = {
      enable = mkEnableOption "set up docker";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && config.home.preferXdgDirectories) {
      home = {
        sessionVariables = {
          DOCKER_CONFIG = "${config.xdg.configHome}/docker";
          MACHINE_STORAGE_PATH = "${config.xdg.dataHome}/docker-machine";
        };
      };
    })
  ];
}
