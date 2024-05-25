{ inputs, ... }:

{
  perSystem =
    { inputs', pkgs, ... }:
    {
      legacyPackages.homeConfigurations = {
        pigeonf = import ./pigeonf { inherit inputs pkgs; };
      };
    };
}
