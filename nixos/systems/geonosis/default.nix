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

        inputs.self.nixosModules.pigeon
        ./disk.nix
      ];

      system.stateVersion = "24.05";

      boot = {
        initrd.availableKernelModules = [ "nvme" ];
        kernelModules = [ "kvm-intel" ];

        loader.grub = {
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      };

      hardware.cpu.intel.updateMicrocode = true;

      services.openssh.enable = true;
      users.users.pigeon.openssh.authorizedKeys.keys = lib.mkForce [ sshKey ];
      users.users.root.openssh.authorizedKeys.keys = lib.mkForce [ sshKey ];
    };
}
