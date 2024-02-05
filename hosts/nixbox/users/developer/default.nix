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

    sessionVariables = {
      GCL_EXTRA_HOST = "local-registry.gitlab.com:host-gateway";
      GCL_VOLUME = "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro";
    };
  };
}
