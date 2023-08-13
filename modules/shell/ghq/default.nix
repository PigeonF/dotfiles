{ pkgs, ... }: {
  home.packages = with pkgs; [
    ghq
  ];

  home.sessionVariables = {
    GHQ_ROOT = "$HOME/git";
  };
}
