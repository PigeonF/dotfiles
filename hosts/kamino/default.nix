{ pkgs, inputs, ... }: {
  imports = [
    ./packages.nix
    ./services.nix
  ];

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    stateVersion = 4;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = "nix-command flakes";
}
