let
  home-modules = import ./modules/flake/home-modules.nix;
in

{
  _file = ./flake-modules.nix;

  inherit home-modules;

  default = _: { imports = [ home-modules ]; };
}
