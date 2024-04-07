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
}
