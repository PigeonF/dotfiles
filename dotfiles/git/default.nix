{ pkgs, ... }:
{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
  };

  xdg.configFile."git/config".source = ./gitconfig;
  xdg.configFile."git/ignore".source = ./gitignore;

  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        delta
        git-absorb
        git-branchless
        git-gone
        git-revise
        git-stack
        meld
        stgit
        uutils-coreutils
        ;
    };

    file.".ssh/allowed_signers".source = ./allowed_signers;
  };
}
