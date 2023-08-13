{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      vim
      just
    ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    casks = [
      "1password"
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
