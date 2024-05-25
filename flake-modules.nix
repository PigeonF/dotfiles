let
  home-modules = import ./modules/flake/home-modules.nix;
in

{
  inherit home-modules;

  default = _: { imports = [ home-modules ]; };
}
