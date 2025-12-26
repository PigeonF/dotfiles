{
  _file = ./default.nix;

  imports = [
    ./home-modules.nix
    ./home-configurations.nix
    ./checks.nix
  ];
}
