{
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ../../../users/common
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
