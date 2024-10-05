{ config, lib, ... }:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in
{
  services = {
    forgejo = {
      enable = true;
      database.type = "postgres";

      lfs.enable = true;
      settings = {
        server = {
          SSH_PORT = lib.mkIf config.services.openssh.enable (builtins.head config.services.openssh.ports);

          PROTOCOL = "http+unix";
          DOMAIN = "git.${config.networking.domain}";
          SSH_DOMAIN = "ssh.${config.networking.domain}";
          ROOT_URL = "https://${srv.DOMAIN}/";
        };

        service.DISABLE_REGISTRATION = true;
        session.COOKIE_SECURE = true;

        actions = {
          ENABLED = false;
          DEFAULT_ACTIONS_URL = "github";
        };

        mailer = {
          ENABLED = false;
          SMTP_ADDR = "mx1.${config.networking.domain}";
          FROM = "noreply@${srv.DOMAIN}";
          USER = "noreply@${srv.DOMAIN}";
        };
      };
    };

    openssh.extraConfig = ''
      match User ${config.services.forgejo.user}
        AuthorizedKeysFile ${config.services.forgejo.stateDir}/.ssh/authorized_keys
    '';

    nginx = {
      virtualHosts = {
        "${srv.DOMAIN}" = {
          forceSSL = true;
          useACMEHost = "${config.networking.domain}";
          extraConfig = ''
            client_max_body_size 512M;
          '';

          locations."/".proxyPass = "http://unix:${srv.HTTP_ADDR}";
        };
      };
    };

  };

  systemd.services.forgejo.preStart =
    let
      user = "root";
    in
    ''
      . "${config.sops.secrets."${config.networking.domain}/forgejo".path}"
      admin="${lib.getExe config.services.forgejo.package} admin user"
      if ! $admin list --admin | tr -s ' ' | cut -d ' ' -f 2 | grep -q "${user}"; then
        $admin create --admin --email "${user}@${srv.DOMAIN}" --username "${user}" --password "$FORGEJO_ADMIN_PASSWORD"
      fi
    '';
}
