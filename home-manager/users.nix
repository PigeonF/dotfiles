{ inputs, ... }:

{
  flake = {
    homeModules =
      let
        mkUser =
          name: imports:
          { pkgs, ... }:
          {
            inherit imports;

            home = {
              username = name;
              homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${name}" else "/home/${name}";
              stateVersion = "24.05";
            };
          };
      in
      {
        pigeon = mkUser "pigeon" (
          builtins.attrValues {
            inherit (inputs.self.homeModules) core common xdg;

            inherit (inputs.self.homeModules.configs) containers rust tools;
          }
        );
      };
  };
}
