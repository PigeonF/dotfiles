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
          };
        };

        nix.settings.trusted-users = [ "pigeon" ];
      };

    vagrant =
      {
        inputs,
        config,
        lib,
        pkgs,
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
          };
        };

        nix.settings.trusted-users = [ "vagrant" ];

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

        # Vagrant keys use RSA
        services.openssh.extraConfig = ''
          PubkeyAcceptedKeyTypes +ssh-rsa
        '';
      };
  };
}
