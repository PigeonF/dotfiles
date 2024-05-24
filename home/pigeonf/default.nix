{ inputs, pkgs, ... }:

inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit inputs;
  };

  modules = [
    (
      { pkgs, ... }:
      {
        home = {
          username = "pigeon";
          homeDirectory = "/home/pigeon";
          stateVersion = "24.05";
          packages = [ pkgs.dotter ];
        };

        xdg.enable = true;
      }
    )
  ];
}
