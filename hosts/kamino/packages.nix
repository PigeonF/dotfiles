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
    zsh.enable = true;
  };
}
