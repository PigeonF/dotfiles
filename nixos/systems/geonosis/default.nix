{ inputs, ... }:

{
  flake.nixosModules.geonosis = _: {
    imports = [
      inputs.self.nixosModules.home-manager
      inputs.disko.nixosModules.disko

      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      inputs.self.nixosModules.core
      inputs.self.nixosModules.docker
      inputs.self.nixosModules.dockerRegistry
      inputs.self.nixosModules.laptop
      inputs.self.nixosModules.nix
      inputs.self.nixosModules.pigeon
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.vsCodeRemoteSSHFix
      inputs.self.nixosModules.webservices
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
  };
}
