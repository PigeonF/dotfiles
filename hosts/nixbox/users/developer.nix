{pkgs, ...}: {
  imports = [
    ../../../users/common
    ../../../dotfiles/bash
  ];

  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        gdb
        nodejs
        rr
        valgrind
        ;
    };

    file.".npmrc" = {
      text = ''
        prefix = ''${HOME}/.npm-packages
      '';
    };

    sessionPath = ["$HOME/.npm-packages/bin"];
  };
}
