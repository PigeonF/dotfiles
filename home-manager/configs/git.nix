{ pkgs, ... }:

{
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
  };

  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        # committed
        delta
        gh
        git-absorb
        git-branchless
        git-gone
        git-revise
        git-stack
        glab
        meld
        stgit
        uutils-coreutils
        ;
    };

    shellAliases = {
      g = "git";
    };

    file.".ssh/allowed_signers".source = ../../dotfiles/git/allowed_signers;
  };
  xdg.configFile."git/config".source = ../../dotfiles/git/gitconfig;
  xdg.configFile."git/ignore".source = ../../dotfiles/git/gitignore;
}
