{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      vim
      just
    ];

  programs = {
    zsh.enable = true;
  };
}
