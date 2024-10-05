{ config, ... }:
let
  cfg = config.services.openssh;
in

{
  services.fail2ban = {
    enable = true;
  };

  services.openssh = {
    enable = true;

    # Frustrate automated scanners by listening on a non-standard port.
    ports = [ 55195 ];

    # Only listen on IPv6, since the IPv4 is not static.
    listenAddresses = map (port: {
      addr = "[::]";
      inherit port;
    }) cfg.ports;

    # Do not bother with RSA keys
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    # We want a read-only configuration, so do not trust keys written to the home directory.
    authorizedKeysInHomedir = false;
    # I have no use for sftp at the moment.
    allowSFTP = false;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };
}
