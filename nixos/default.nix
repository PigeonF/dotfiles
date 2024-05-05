{
  imports = [
    ./core.nix
    ./docker.nix
    ./dockerRegistry.nix
    ./gitlab-runner
    ./laptop.nix
    ./network.nix
    ./ssh.nix
    ./systems
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
