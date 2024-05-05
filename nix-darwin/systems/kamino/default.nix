{ inputs, ... }:
{
  imports = [
    inputs.self.darwinModules.home-manager

    ../../users/pigeon.nix

    ../../../shared/core.nix
    ../../../shared/nix.nix
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
}
