{ inputs, ... }:

{
  flake.nixosModules.geonosis = _: {
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
  };
}
