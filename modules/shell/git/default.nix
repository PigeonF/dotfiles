{pkgs, ...}: {
  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
  };

  xdg.configFile."git/config".source = ./gitconfig;
  xdg.configFile."git/ignore".source = ./gitignore;

  home = {
    packages = with pkgs; [
      delta
      git-branchless
      meld
      stgit
      uutils-coreutils
    ];

    file.".ssh/allowed_signers".source = ./allowed_signers;
  };
}
