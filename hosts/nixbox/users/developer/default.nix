{ pkgs, ... }:
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
      text = ''
        PRIVILEGED=true
        EXTRA_HOST="local-registry.gitlab.com:host-gateway"
        VOLUME="certs:/certs/client /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro"
      '';
    };
  };
}
