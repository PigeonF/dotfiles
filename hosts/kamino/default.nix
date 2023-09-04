{ pkgs, inputs, user, ... }: {
  imports = [
    ./services.nix
  ];

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    stateVersion = 4;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      allowed-users = [ user ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "act"
    ];
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
