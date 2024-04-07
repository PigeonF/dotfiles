{ inputs, ... }:

{
  flake.nixosModules.geonosis =
    { lib, ... }:
    let
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILt6md+QmEdseqB8kRqrsTIOvGsph+um1Lb5xijO7Vfj";
    in
    {
      imports = [
        inputs.self.nixosModules.home-manager
        inputs.disko.nixosModules.disko

        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

        inputs.self.nixosModules.sshRoot
        inputs.self.nixosModules.pigeon
        ./disk.nix
      ];

      boot.loader.grub = {
        devices = [ "/dev/nvme0" ];

        efiSupport = true;
        efiInstallAsRemovable = true;
      };

      system.stateVersion = "24.05";

      users.users.pigeon.openssh.authorizedKeys.keys = lib.mkForce [ sshKey ];
      users.users.root.openssh.authorizedKeys.keys = lib.mkForce [ sshKey ];
    };
}
