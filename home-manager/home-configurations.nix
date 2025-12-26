{ inputs, ... }:
let
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
  inherit (inputs.self) homeModules;
in
{
  _file = ./home-configurations.nix;

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
}
