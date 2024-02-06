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
            "/etc/buildkit/buildkitd.default.toml:/etc/buildkit/buildkitd.default.toml:ro"
            "/etc/docker/certs.d/:/etc/docker/certs.d/:ro"
          ];
        in
        ''
          PRIVILEGED=true
          VOLUME="${volumes}"
          VARIABLE=BUILDX_CONFIG=/etc/buildkit
        '';
    };
  };
}
