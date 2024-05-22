{ pkgs, config, ... }:

{
  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        crane
        diffoci
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
      BUILDX_CONFIG = "${config.xdg.dataHome}/buildx";
      REGCTL_CONFIG = "${config.xdg.dataHome}/regctl/config.json";
    };
  };

  xdg.dataFile."buildx/buildkitd.default.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "/etc/buildkit/buildkitd.toml";
  };
}
