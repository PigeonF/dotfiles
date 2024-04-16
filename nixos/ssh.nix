_:

{

  flake.nixosModules = {
    ssh =
      { lib, ... }:
      {
        services.openssh = {
          enable = lib.mkDefault true;
          openFirewall = lib.mkDefault true;
          extraConfig = ''
            AcceptEnv LANG LANGUAGE LC_*
            AcceptEnv COLORTERM TERM TERM_*
            AcceptEnv WEZTERM_REMOTE_PANE
          '';
          settings = {
            Macs = [ "hmac-sha2-512" ];
          };
        };

        security.sudo.extraConfig = ''
          Defaults env_keep+=SSH_AUTH_SOCK
        '';
      };
  };
}
