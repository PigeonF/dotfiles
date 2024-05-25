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
        imports = [ inputs.self.homeModules.default ];

        home = {
          username = "pigeon";
          homeDirectory = "/home/pigeon";
          stateVersion = "24.05";
          packages = [ pkgs.dotter ];
        };

        nix = {
          enable = true;
          package = pkgs.nix;
          settings = {
            use-xdg-base-directories = true;
          };
        };

        xdg.enable = true;

        pigeonf = {
          vscodium.enable = true;
        };
      }
    )
  ];
}
