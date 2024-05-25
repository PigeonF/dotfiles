{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      legacyPackages.homeConfigurations = {
        pigeonf = import ./pigeonf { inherit inputs pkgs; };
        root = import ./root { inherit inputs pkgs; };
      };
    };
}
