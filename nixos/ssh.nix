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
      Macs = [
        "hmac-sha2-512"
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
    };
  };

  security.sudo.extraConfig = ''
    Defaults env_keep+=SSH_AUTH_SOCK
  '';
}
