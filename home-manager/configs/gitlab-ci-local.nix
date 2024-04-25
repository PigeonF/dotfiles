{
  config,
  pkgs,
  lib,
  ...
}:

{
  home = {
    packages = [ pkgs.gitlab-ci-local ];

    sessionVariables = {
      GCL_HOME = "${config.xdg.configHome}/gitlab-ci-local";
      GCL_ARTIFACTS_TO_SOURCE = "false";
    };
  };

  xdg.configFile.".gitlab-ci-local/.env" = {
    text =
      let
        volumes = lib.strings.concatStringsSep " " [
          "builds:/builds"
          "cache:/cache"
          "certs:/certs/client"
          "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro"
        ];
        variables = lib.strings.concatStringsSep " " [ "SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt" ];
      in
      ''
        PRIVILEGED=true
        VOLUME="${volumes}"
        VARIABLE="${variables}"
      '';
  };
}
