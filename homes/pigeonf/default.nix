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
          homeDirectory = if pkgs.stdenv.isDarwin then "/Users/pigeonf" else "/home/pigeonf";
          stateVersion = "24.05";
          packages = [ pkgs.dotter ];
        };

        nix = {
          enable = true;
          package = pkgs.nix;
          settings = {
            use-xdg-base-directories = true;
            substituters = [
              "https://cache.nixos.org"
              "https://cachix.cachix.org"
              "https://nix-community.cachix.org"
            ];

            # extra-substituters = [
            #   "ssh-ng://alice"
            # ];

            trusted-public-keys = [
              "alice:R++4LTYSvoZ5PpnvzJ5FjiTaWHcnUoOndTt6gAu269w="
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
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
