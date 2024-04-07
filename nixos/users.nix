{ inputs, ... }:

{
  flake.nixosModules.pigeon =
    { config, lib, ... }:
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
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
          ];
          isNormalUser = true;
        };
      };

      nix.settings.trusted-users = [ "pigeon" ];
    };
}
