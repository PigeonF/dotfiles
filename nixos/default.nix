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
    vsCodeRemoteSSHFix =
      { pkgs, ... }:
      {
        programs.nix-ld.enable = true;

        environment.systemPackages = builtins.attrValues { inherit (pkgs) uutils-coreutils-noprefix wget; };
      };
  };
}
