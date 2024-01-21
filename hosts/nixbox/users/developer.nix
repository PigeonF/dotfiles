{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ../../../users/common
    ../../../modules/shell/bash
  ];

  home = {
    packages = with pkgs; [
      gdb
      nodejs
      rr
      valgrind
    ];

    file.".npmrc" = {
      text = ''
        prefix = ''${HOME}/.npm-packages
      '';
    };

    sessionPath = ["$HOME/.npm-packages/bin"];
  };
}
