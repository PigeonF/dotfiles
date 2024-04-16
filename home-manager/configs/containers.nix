{ pkgs, config, ... }:

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
      DOCKER_CONFIG = "${config.xdg.dataHome}/docker";
    };
  };
}
