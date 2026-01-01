{ inputs, ... }:
let
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  inherit (inputs.self) homeModules;
in
{
  _file = ./home-configurations.nix;

  deploy-rs = {
    nodes =
      let
        inherit (inputs.self) homeConfigurations;
        home-manager-x86_64 = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager;
      in
      {
        hl-vhost-x-01 = {
          hostname = "hl-vhost-x-01";
          profilesOrder = [
            "root"
            "administrator"
          ];
          profiles = {
            root = {
              user = "root";
              sshUser = "administrator";
              path = home-manager-x86_64 homeConfigurations."root@x86_64-linux";
            };
            administrator = {
              user = "administrator";
              sshUser = "administrator";
              path = home-manager-x86_64 homeConfigurations."administrator@hl-vhost-x-01";
            };
          };
        };
        hl-dev-x-01 = {
          hostname = "hl-dev-x-01";
          profilesOrder = [
            "root"
            "developer"
          ];
          profiles = {
            root = {
              user = "root";
              sshUser = "developer";
              path = home-manager-x86_64 homeConfigurations."root@x86_64-linux";
            };
            developer = {
              user = "developer";
              sshUser = "developer";
              path = home-manager-x86_64 homeConfigurations."developer@hl-dev-x-01";
            };
          };
        };
        hl-ci-x-01 = {
          hostname = "hl-ci-x-01";
          profilesOrder = [
            "root"
          ];
          profiles = {
            root = {
              user = "root";
              sshUser = "root";
              path = home-manager-x86_64 homeConfigurations."root@x86_64-linux";
            };
          };
        };
        hl-ci-x-02 = {
          hostname = "hl-ci-x-02";
          profilesOrder = [
            "root"
          ];
          profiles = {
            root = {
              user = "root";
              sshUser = "root";
              path = home-manager-x86_64 homeConfigurations."root@x86_64-linux";
            };
          };
        };
      };

  };

  flake = {
    homeConfigurations =
      let
        makePkgs = system: import inputs.nixpkgs { inherit system; };
        pkgs-x86_64-linux = makePkgs "x86_64-linux";
      in
      {
        "administrator@hl-vhost-x-01" = homeManagerConfiguration {
          pkgs = pkgs-x86_64-linux;
          modules = [ homeModules.administrator ];
        };
        "developer@hl-dev-x-01" = homeManagerConfiguration {
          pkgs = pkgs-x86_64-linux;
          modules = [ homeModules.developer ];
        };
        "reviewer@hl-dev-x-02" = homeManagerConfiguration {
          pkgs = pkgs-x86_64-linux;
          modules = [ homeModules.reviewer ];
        };
        "root@x86_64-linux" = homeManagerConfiguration {
          pkgs = pkgs-x86_64-linux;
          modules = [ homeModules.root ];
        };
        "user@Spore" = homeManagerConfiguration {
          pkgs = pkgs-x86_64-linux;
          modules = [ homeModules.user ];
        };
      };
  };

  perSystem =
    { lib, system, ... }:
    {
      checks = lib.mapAttrs' (
        name: v: lib.nameValuePair ("homeManagerConfiguration." + name) v.activationPackage
      ) (lib.filterAttrs (_: v: v.pkgs.stdenv.system == system) inputs.self.homeConfigurations);
    };
}
