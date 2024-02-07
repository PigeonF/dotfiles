systemConfig:
{
  config,
  pkgs,
  lib,
  ...
}:
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

    file.".gitlab-ci-local/buildkitd.default.toml" = {
      text = ''
        [registry."${systemConfig.nixbox.registryHost}"]
          ca=["/etc/docker/certs.d/${systemConfig.nixbox.registryHost}/ca.crt"]
      '';
    };

    file.".gitlab-ci-local/.env" = {
      text =
        let
          home = config.home.homeDirectory;
          volumes = lib.strings.concatStringsSep " " [
            "certs:/certs/client"
            "${home}/.gitlab-ci-local/buildkitd.default.toml:/etc/buildkit/buildkitd.toml:ro"
            "/etc/docker/certs.d/:/etc/docker/certs.d/:ro"
          ];
        in
        ''
          PRIVILEGED=true
          ARTIFACTS_TO_SOURCE=false
          VOLUME="${volumes}"
        '';
    };
  };
}
