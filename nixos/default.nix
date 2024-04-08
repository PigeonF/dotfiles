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

        security.sudo.extraConfig = ''
          Defaults env_keep+=SSH_AUTH_SOCK
        '';
      };

    vsCodeRemoteSSHFix = _: { programs.nix-ld.enable = true; };
  };
}
