systemConfig:
{ pkgs, lib, ... }:
{
  imports = [
    ../../../../users/common
    ../../../../dotfiles/bash
  ];

  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        gdb
        gitlab-ci-local
        nodejs
        rr
        valgrind
        ;
    };

    file.".gitlab-ci-local/.env" = {
      text =
        let
          volumes = lib.strings.concatStringsSep " " [
            "certs:/certs/client"
            "/etc/buildkit/buildkitd.toml:/etc/buildkit/buildkitd.toml:ro"
            "/etc/docker/certs.d/${systemConfig.nixbox.registryHost}/ca.crt:/etc/docker/certs.d/${systemConfig.nixbox.registryHost}/ca.crt:ro"
          ];
        in
        ''
          PRIVILEGED=true
          VOLUME="${volumes}"
        '';
    };
  };
}
