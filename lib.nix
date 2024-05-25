{ inputs, ... }:

{
  flake.lib = {
    mkNixosConfiguration =
      system: modules:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
          isLinux = true;
        };

        modules = modules ++ [
          (
            { lib, ... }:
            {
              system.stateVersion = lib.mkDefault "24.05";
              nixpkgs.hostPlatform = lib.mkDefault system;
            }
          )
        ];
      };
  };
}
