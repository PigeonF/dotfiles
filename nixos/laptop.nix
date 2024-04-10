_:

{
  flake.nixosModules = {
    laptop = _: {
      # Do not suspend when closing lid while being charged.
      hardware.cpu.intel.updateMicrocode = true;

      services = {
        dbus.enable = true;
        logind.lidSwitchExternalPower = "ignore";
        logrotate.checkConfig = false;
        timesyncd.enable = true;
      };
    };
  };
}
