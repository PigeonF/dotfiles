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
      BUILDX_CONFIG = "${config.xdg.dataHome}/buildx";
    };
  };

  xdg.dataFile."buildx/buildkitd.default.toml" = {
    text = ''
      [registry."registry.internal"]
        ca=["/etc/docker/certs.d/registry.internal/ca.crt"]
    '';
  };
}
