{ pkgs, ... }: {
  home = {
    packages = builtins.attrValues { inherit (pkgs) ghq; };

    sessionVariables = { GHQ_ROOT = "$HOME/git"; };
  };
}
