{ pkgs, ... }:

{
  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        crane
        diffoscopeMinimal
        dive
        docker-client
        podman
        regctl
        skopeo
        ;
    };

    sessionVariables = {
      DOCKER_CONFIG = "$XDG_DATA_HOME/docker";
    };
  };
}