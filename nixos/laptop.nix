_:

{
  flake.nixosModules = {
    laptop = _: {
      hardware = {
        # Do not suspend when closing lid while being charged.
        cpu.intel.updateMicrocode = true;
        enableRedistributableFirmware = true;
      };

      services = {
        logind.lidSwitchExternalPower = "ignore";
        logrotate.checkConfig = false;
      };
    };
  };
}
