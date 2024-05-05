{
  imports = [
    ./extras/darwinModules.nix
    ./extras/homeModules.nix
    ./nix-darwin/modules/home-manager.nix
    ./nixos/modules/home-manager.nix
    ./nixos/modules/gitlab-runner.nix
  ];
}
