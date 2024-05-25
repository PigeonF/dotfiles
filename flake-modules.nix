let
  homeManagerModules = {
    vscodium = import ./modules/home/vscodium;
  };

  homeModules = {
    vscodium = _: { flake.homeModules.vscodium = homeManagerModules.vscodium; };

    default = _: {
      flake.homeModules.vscodium = homeManagerModules.vscodium;
      flake.homeModules.default = _: { imports = builtins.attrValues homeManagerModules; };
    };
  };
in

{
  inherit homeModules;

  default = _: { imports = [ homeModules.default ]; };
}
