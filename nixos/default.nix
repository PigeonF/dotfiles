{
  imports = [
    ./users.nix
    ./systems
  ];

  flake.nixosModules = {
    laptop = _: {
      # Do not suspend when closing lid while being charged.
      services.logind.lidSwitchExternalPower = "ignore";
      hardware.cpu.intel.updateMicrocode = true;
    };

    vsCodeRemoteSSHFix = _: { programs.nix-ld.enable = true; };
  };
}
