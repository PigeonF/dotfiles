{
  flake.darwinModules = {
    pigeon =
      { inputs, pkgs, ... }:
      {
        home-manager.users.pigeon = inputs.self.homeModules.users.pigeon;

        users = {
          users.pigeon = {
            home = "/Users/pigeon";
            shell = pkgs.zsh;
          };
        };

        nix.settings.trusted-users = [ "pigeon" ];
      };
  };
}
