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
        gitlab-ci-local
        ;
    };
  };
}
