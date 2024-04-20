{ inputs, ... }:

{
  flake.nixosModules.mustafar =
    { pkgs, ... }:
    {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/profiles/hardened.nix"
        inputs.self.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops

        inputs.self.nixosModules.core
        inputs.self.nixosModules.coreLinux
        inputs.self.nixosModules.network
        inputs.self.nixosModules.nix
        inputs.self.nixosModules.vagrant
        inputs.self.nixosModules.ssh
        inputs.self.nixosModules.vsCodeRemoteSSHFix
        inputs.self.nixosModules.gitlab-runner
        ./disk.nix
      ];

      networking.hostName = "mustafar";

      sops.secrets."gitlab-runner/environment" = {
        sopsFile = ./gitlab-runner-default.env;
        format = "dotenv";
        restartUnits = [ "gitlab-runner.service" ];
      };

      boot = {
        initrd = {
          checkJournalingFS = false;
          availableKernelModules = [
            "ata_piix"
            "sd_mod"
            "sr_mod"
          ];
        };

        loader.grub = {
          enable = true;
          device = "/dev/sda";
        };
      };

      # For some reason changing this seems to lead to a crash in the current
      # VirtualBox version. As mustafar does not require guest additions, we
      # can just disable it.
      virtualisation.virtualbox.guest.enable = false;

      users = {
        mutableUsers = false;
        users.root = {
          hashedPassword = "!";
        };
      };

      nix.gc.automatic = true;
      nix.optimise.automatic = true;

      # Required by vagrant
      environment.systemPackages = builtins.attrValues {
        inherit (pkgs)
          findutils
          gnumake
          iputils
          jq
          nettools
          netcat
          nfs-utils
          rsync
          ;
      };

      # Allow passwordless sudo
      security.sudo.extraConfig = ''
        %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
      '';

      # Vagrant keys use RSA
      services.openssh.extraConfig = ''
        PubkeyAcceptedKeyTypes +ssh-rsa
      '';
    };
}
