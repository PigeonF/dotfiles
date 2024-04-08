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
          };
        };

        nix.settings.trusted-users = [ "pigeon" ];
      };
  };
}
