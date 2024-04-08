{
  imports = [
    ./nix.nix
    ./systems
    ./users.nix
  ];

  flake.nixosModules = {
    core =
      { inputs, lib, ... }:
      {
        networking = {
          useDHCP = lib.mkDefault true;
          firewall.enable = lib.mkDefault true;
        };

        time = {
          timeZone = lib.mkDefault "Europe/Berlin";
        };

        system = {
          configurationRevision = lib.mkDefault (inputs.self.rev or inputs.self.dirtyRev or null);
        };

        services = {
          dbus.enable = true;
          timesyncd.enable = true;
          logrotate.checkConfig = false;
        };
      };

    docker = _: {
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
    };

    laptop = _: {
      # Do not suspend when closing lid while being charged.
      services.logind.lidSwitchExternalPower = "ignore";
      hardware.cpu.intel.updateMicrocode = true;
    };

    ssh =
      { lib, ... }:
      {
        services.openssh.enable = lib.mkDefault true;
        services.openssh.openFirewall = lib.mkDefault true;

        security.sudo.extraConfig = ''
          Defaults env_keep+=SSH_AUTH_SOCK
        '';
      };

    vsCodeRemoteSSHFix = _: { programs.nix-ld.enable = true; };
  };
}
