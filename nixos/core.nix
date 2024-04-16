_:

{
  flake.nixosModules = {
    core =
      { inputs, lib, ... }:
      {
        time = {
          timeZone = lib.mkDefault "Europe/Berlin";
        };

        system = {
          configurationRevision = lib.mkDefault (inputs.self.rev or inputs.self.dirtyRev or null);
        };

        environment = {
          enableAllTerminfo = true;
        };
      };
  };
}
