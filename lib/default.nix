{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
  mkOsConfiguration =
    fn:
    {
      config,
      extraModules,
      hmStateVersion,
      home-manager,
      home,
      name,
      sharedHomeManagerModules,
      stateVersion,
      system,
    }:
    fn {
      inherit system;
      specialArgs = {
        inherit name inputs;
      };
      modules =
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ inputs.self.outputs.overlays.additions ];
          };
        in
        [
          (
            { name, inputs, ... }:
            {
              system = {
                inherit stateVersion;
                configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
              };
              networking.hostName = name;
              time.timeZone = "Europe/Berlin";
              nix = {
                settings = {
                  sandbox = true;

                  experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                  auto-optimise-store = true;
                  substituters = [
                    "https://cache.nixos.org/"
                    "https://cachix.cachix.org"
                    "https://nix-community.cachix.org"
                  ];
                  trusted-public-keys = [
                    "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                  ];
                };
                registry.nixpkgs.flake = inputs.nixpkgs;

                nixPath = [
                  "nixpkgs=/etc/nixpkgs/channels/nixpkgs"
                  "/nix/var/nix/profiles/per-user/root/channels"
                ];
              };
            }
          )
          (import config)
        ]
        ++ extraModules
        ++ (
          if home != null then
            [
              home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs pkgs;
                    stateVersion = hmStateVersion;
                  };
                  sharedModules = sharedHomeManagerModules;
                };
              }
              home
            ]
          else
            [ ]
        );
    };
in
rec {
  forEachSystem =
    lambda:
    lib.genAttrs
      [
        "x86_64-linux"
        "aarch64-darwin"
      ]
      (
        system:
        lambda (
          import inputs.nixpkgs {
            inherit system;
            overlays = [ inputs.self.outputs.overlays.additions ];
          }
        )
      );

  mkNixOsConfigurations = lib.mapAttrs' mkNixOsConfiguration;
  mkNixOsConfiguration =
    name:
    {
      system,
      config,
      stateVersion ? "24.05",
      home ? null,
      extraModules ? [ ],
      sharedHomeManagerModules ? [ ],
    }:
    lib.nameValuePair name (
      mkOsConfiguration lib.nixosSystem {
        inherit (inputs.home-manager.nixosModules) home-manager;
        inherit
          system
          config
          stateVersion
          home
          name
          sharedHomeManagerModules
          ;

        extraModules = extraModules ++ [
          (
            { ... }:
            {
              nix = {
                daemonCPUSchedPolicy = "idle";
                daemonIOSchedPriority = 3;
              };
              systemd.tmpfiles.rules = [ "L+ /etc/nixpkgs/channels/nixpkgs     - - - - ${inputs.nixpkgs}" ];
            }
          )
        ];
        hmStateVersion = stateVersion;
      }
    );

  mkDarwinConfigurations = lib.mapAttrs' mkDarwinConfiguration;
  mkDarwinConfiguration =
    name:
    {
      system,
      config,
      stateVersion ? 4,
      hmStateVersion ? "24.05",
      home ? null,
      extraModules ? [ ],
      sharedHomeManagerModules ? [ ],
    }:
    lib.nameValuePair name (
      mkOsConfiguration inputs.nix-darwin.lib.darwinSystem {
        inherit
          system
          config
          stateVersion
          hmStateVersion
          home
          name
          extraModules
          sharedHomeManagerModules
          ;

        inherit (inputs.home-manager.darwinModules) home-manager;
      }
    );
}
