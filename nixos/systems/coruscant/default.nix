{ inputs, ... }:

{
  flake.nixosModules.coruscant =
    { config, ... }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.wsl

        inputs.self.nixosModules.core
        inputs.self.nixosModules.home-manager
        inputs.self.nixosModules.nix
        inputs.self.nixosModules.pigeon
      ];

      networking.hostName = "coruscant";

      wsl = {
        enable = true;
        defaultUser = "pigeon";
      };
    };
}
