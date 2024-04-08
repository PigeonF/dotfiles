{ inputs, ... }:

{
  flake.nixosModules.mustafar =
    { lib, ... }:
    let
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF17mBkVi/0dKz4hgn4ZdM1qPzqMKZacXVbHpM1pddNU";
    in
    {
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

      # Inserted via Vagrant
      sops.age.keyFile = "/var/lib/sops-nix/keys.txt";

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
          openssh.authorizedKeys.keys = lib.mkForce [ sshKey ];
        };
        users.vagrant.openssh.authorizedKeys.keys = lib.mkForce [ sshKey ];
      };

      nix.gc.automatic = true;
      nix.optimise.automatic = true;
    };
}
