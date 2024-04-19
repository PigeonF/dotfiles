{
  flake.nixosModules = {
    pigeon =
      {
        inputs,
        config,
        lib,
        ...
      }:
      {
        home-manager.users.pigeon = inputs.self.homeModules.users.pigeon;

        users = {
          groups.pigeon = {
            name = "pigeon";
            members = [ "pigeon" ];
          };

          users.pigeon = {
            description = "Developer Account";
            name = "pigeon";
            group = "pigeon";
            extraGroups = [
              "users"
              "wheel"
            ] ++ lib.lists.optional config.virtualisation.docker.enable "docker";
            home = "/home/pigeon";
            createHome = true;
            useDefaultShell = true;
            isNormalUser = true;
            initialPassword = "pigeon";
            openssh.authorizedKeys.keys = lib.mkForce [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
            ];
          };
        };

        programs._1password.enable = true;
        programs._1password-gui = {
          enable = true;
          polkitPolicyOwners = [ "pigeon" ];
        };

        nix.settings.trusted-users = [ "pigeon" ];
      };

    vagrant =
      {
        inputs,
        config,
        lib,
        ...
      }:
      {
        home-manager.users.vagrant = inputs.self.homeModules.users.vagrant;

        users = {
          groups.vagrant = {
            name = "vagrant";
            members = [ "vagrant" ];
          };

          users.vagrant = {
            description = "Developer Account";
            name = "vagrant";
            group = "vagrant";
            extraGroups = [
              "users"
              "wheel"
              "vboxsf"
            ] ++ lib.lists.optional config.virtualisation.docker.enable "docker";
            home = "/home/vagrant";
            createHome = true;
            useDefaultShell = true;
            isNormalUser = true;
            hashedPassword = "!";
            openssh.authorizedKeys.keys = lib.mkForce [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
            ];
          };
        };

        nix.settings.trusted-users = [ "vagrant" ];
      };
  };
}
