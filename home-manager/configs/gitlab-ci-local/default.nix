{ pkgs, lib, ... }:

{
  # sops.secrets."gitlab-ci-local" = {
  #   sopsFile = ./secrets.ini;
  #   format = "ini";
  # };

  home = {
    packages = [ pkgs.gitlab-ci-local ];

    sessionVariables = {
      GCL_ARTIFACTS_TO_SOURCE = "false";
    };

    file = {
      ".gitlab-ci.local/.keep".source = builtins.toFile "keep" "";

      ".gitlab-ci-local/.env" = {
        text =
          let
            volumes = lib.strings.concatStringsSep " " [
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
    };
  };

  # systemd.user.services.gitlab-ci-local-variables = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  #   Unit = {
  #     Description = "gitlab-ci-local variables.yml activation";
  #     After = [ "sops-nix.service" ];
  #   };

  #   Service =
  #     let
  #       secrets = builtins.replaceStrings [ "%r" ] [ "%t" ] config.sops.secrets."gitlab-ci-local".path;
  #     in
  #     {
  #       Type = "oneshot";
  #       UMask = "0077";
  #       ExecStart = "${lib.getExe pkgs.jinja2-cli} -o %t/gitlab-ci-local-variables.yaml --strict --format=ini ${./variables.yaml} ${secrets}";
  #       ExecStartPost = "${lib.getExe' pkgs.coreutils "ln"} -s %t/gitlab-ci-local-variables.yaml %h/.gitlab-ci-local/variables.yml";
  #     };
  # };

  # home.activation.gitlab-ci-local-variables = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
  #   config.lib.dag.entryAfter [ "sops-nix" ] ''
  #     /run/current-system/sw/bin/systemctl start --user gitlab-ci-local-variables
  #   ''
  # );
}
