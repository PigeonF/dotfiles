{
  flake.nixosModules.nix =
    { inputs, ... }:
    {
      nix = {
        settings = {
          sandbox = true;
          use-xdg-base-directories = true;

          experimental-features = [
            "auto-allocate-uids"
            "flakes"
            "nix-command"
            "repl-flake"
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

        # Make flake nixpkgs available
        nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
        registry.nixpkgs.flake = inputs.nixpkgs;
      };
    };
}