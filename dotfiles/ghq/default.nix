{ pkgs, ... }: {
  home.packages = builtins.attrValues {
    inherit (pkgs) ghq;
  };

  home.sessionVariables = {
    GHQ_ROOT = "$HOME/git";
  };
}
