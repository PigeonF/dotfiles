_:

{
  flake.nixosModules.docker = _: {
    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          bip = "10.117.0.1/16";
          default-address-pools = [
            {
              base = "10.118.0.0/16";
              size = 24;
            }
          ];
        };
      };
    };

    networking.firewall.trustedInterfaces = [ "docker0" ];
  };
}
