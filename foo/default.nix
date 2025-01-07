# SPDX-FileCopyrightText: 2025 Jonas Fierlings <fnoegip@gmail.com>
#
# SPDX-License-Identifier: 0BSD
{
  inputs,
  ...
}:
{
  _file = ./default.nix;

  flake = {
    deploy.nodes.foo = {
      hostname = "foo.incus";
      profilesOrder = [ "system" ];
      profiles = {
        system = {
          sshUser = "pigeonf";
          user = "root";
          sudo = "doas -u";
          sshOpts = [ ];
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.foo;
        };
      };
    };

    nixosConfigurations = {
      foo = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./nixos.nix
          ./hardware-configuration.nix
        ];
      };
    };
  };
}
