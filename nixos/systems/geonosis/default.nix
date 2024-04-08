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

        inputs.self.nixosModules.core
        inputs.self.nixosModules.docker
        inputs.self.nixosModules.laptop
        inputs.self.nixosModules.nix
        inputs.self.nixosModules.pigeon
        inputs.self.nixosModules.ssh
        inputs.self.nixosModules.vsCodeRemoteSSHFix
        ./disk.nix
      ];

      system.stateVersion = "24.05";
      networking.hostName = "geonosis";

      boot = {
        initrd.availableKernelModules = [ "nvme" ];
        kernelModules = [ "kvm-intel" ];

        loader.grub = {
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      };

      users.users.pigeon.openssh.authorizedKeys.keys = lib.mkForce [ sshKey ];
      users.users.root.openssh.authorizedKeys.keys = lib.mkForce [ sshKey ];
    };
}
