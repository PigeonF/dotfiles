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
          username = "pigeonf";
          homeDirectory = "/home/pigeonf";
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

        programs.home-manager.enable = true;
        xdg.enable = true;

        pigeonf = {
          admintools.enable = true;
          atuin.enable = true;
          bash.enable = true;
          devtools.enable = true;
          git.enable = true;
          helix.enable = true;
          latex.enable = true;
          nushell.enable = true;
          nvim.enable = true;
          python.enable = true;
          ruby.enable = true;
          rust.enable = true;
          starship.enable = true;
          vscodium.enable = true;
          zellij.enable = true;
          zoxide.enable = true;
        };
      }
    )
  ];
}
