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

    environment.variables = {
      SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
    };

    services.nix-daemon.enable = true;
  };
}
