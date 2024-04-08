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

    vsCodeRemoteSSHFix = _: { programs.nix-ld.enable = true; };
  };
}
