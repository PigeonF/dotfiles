{
  imports = [
    ./core.nix
    ./docker.nix
    ./dockerRegistry.nix
    ./laptop.nix
    ./network.nix
    ./nix.nix
    ./ssh.nix
    ./systems
    ./users.nix
    ./webservices.nix
  ];

  flake.nixosModules = {
    vsCodeRemoteSSHFix = _: { programs.nix-ld.enable = true; };
  };
}
