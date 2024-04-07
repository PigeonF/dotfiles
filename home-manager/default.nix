{
  imports = [ ./users.nix ];

  flake = {
    homeModules = {
      common = _: { imports = [ ../users/common ]; };
    };
  };
}
