{ inputs, ... }:

{
  flake.nixosModules.geonosis = _: {
    imports = [
      inputs.self.nixosModules.home-manager
      inputs.disko.nixosModules.disko

      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

      inputs.self.nixosModules.pigeon
      ./disk.nix
    ];

    boot.loader.grub = {
      devices = [ "/dev/nvme0" ];

      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    services.openssh.enable = true;

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
    ];

    system.stateVersion = "24.05";
  };
}
