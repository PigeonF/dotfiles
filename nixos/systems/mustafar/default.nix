{ inputs, ... }:

{
  flake.nixosModules.mustafar = _: {
    imports = [
      "${inputs.nixpkgs}/nixos/modules/profiles/hardened.nix"
      inputs.self.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops

      inputs.self.nixosModules.core
      inputs.self.nixosModules.nix
      inputs.self.nixosModules.vagrant
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.vsCodeRemoteSSHFix
      ./gitlab-runner.nix
      ./disk.nix
    ];

    system.stateVersion = "24.05";
    networking.hostName = "mustafar";

    boot = {
      initrd.checkJournalingFS = false;

      loader.grub = {
        enable = true;
        device = "/dev/sda";
      };
    };

    virtualisation.virtualbox.guest.enable = true;
    systemd.coredump.enable = false;

    users = {
      mutableUsers = false;
      users.root = {
        hashedPassword = "!";
      };
    };

    nix.gc.automatic = true;
    nix.optimise.automatic = true;
  };
}
