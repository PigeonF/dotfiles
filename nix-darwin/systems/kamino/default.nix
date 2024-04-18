{ inputs, ... }:

{
  flake.darwinModules.kamino = _: {
    imports = [
      inputs.self.darwinModules.home-manager
      inputs.self.darwinModules.pigeon

      inputs.self.nixosModules.core
      inputs.self.nixosModules.nix
    ];

    networking.hostName = "kamino";

    system = {
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };
    };

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
      };
      brews = [ "act" ];
      casks = [
        "1password"
        "alacritty"
        "docker"
        "dropbox"
        "spotify"
        "visual-studio-code"
      ];
    };

    services.nix-daemon.enable = true;
  };
}
