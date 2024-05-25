let
  homeManagerModules = {
    git = import ./modules/home/git;
    vscodium = import ./modules/home/vscodium;
  };

  homeModules =
    let
      f = name: value: (_: { flake.homeModules."${name}" = value; });
    in
    (builtins.mapAttrs f homeManagerModules)
    // {
      default = _: {
        flake.homeModules = homeManagerModules // {
          default = _: { imports = builtins.attrValues homeManagerModules; };
        };
      };
    };
in

{
  inherit homeModules;

  default = _: { imports = [ homeModules.default ]; };
}
