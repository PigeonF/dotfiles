_:

{

  flake.nixosModules = {
    ssh =
      { lib, ... }:
      {
        services.openssh.enable = lib.mkDefault true;
        services.openssh.openFirewall = lib.mkDefault true;
        services.openssh.extraConfig = ''
          AcceptEnv LANG LANGUAGE LC_*
          AcceptEnv COLORTERM TERM TERM_*
          AcceptEnv WEZTERM_REMOTE_PANE
        '';

        security.sudo.extraConfig = ''
          Defaults env_keep+=SSH_AUTH_SOCK
        '';
      };
  };
}
