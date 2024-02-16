{ pkgs, ... }:
{
  imports = [ ./services ];

  # Specified here to change the login shell.
  users.users = {
    pigeon = {
      home = "/Users/pigeon";
      shell = pkgs.zsh;
    };
  };

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  nix.settings.trusted-users = [ "pigeon" ];

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
      "spotify"
      "visual-studio-code"
    ];
  };

  programs = {
    zsh = {
      enable = true;
      variables = {
        SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
    };
  };
}
