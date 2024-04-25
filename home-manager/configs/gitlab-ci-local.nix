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

  xdg.configFile = {
    "gitlab-ci-local/.gitlab-ci-local/.env" = {
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

    "gitlab-ci-local/.gitlab-ci-local/variables.yml" = {
      text = ''
        ---
        global:
          CI: "true"
          CI_API_GRAPHQ_URL: https://gitlab.com/api/graphql
          CI_BUILDS_DIR: /gcl-builds
          CI_CONFIG_PATH: .gitlab-ci.yml
          CI_PIPELINE_SOURCE: "merge_request_event"
          CI_MERGE_REQUEST_TARGET_BRANCH_NAME: main
          GITLAB_USER_ID: 409429
          GITLAB_USER_LOGIN: PigeonF
      '';
    };
  };
}
