{ inputs, ... }:

{
  flake.nixosModules.coruscant =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.wsl

        inputs.self.nixosModules.core
        inputs.self.nixosModules.home-manager
        inputs.self.nixosModules.nix
        inputs.self.nixosModules.pigeon

        inputs.self.nixosModules.vsCodeRemoteSSHFix
      ];

      networking.hostName = "coruscant";

      wsl = {
        enable = true;
        defaultUser = "pigeon";
      };

      environment.defaultPackages = [ pkgs.socat ];
    };
}
