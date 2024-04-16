{ config, pkgs, ... }:

{
  home = {
    packages = [ pkgs.rustup ];

    shellAliases = {
      c = "cargo";
    };

    sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };

    sessionPath = [ "$CARGO_HOME/bin" ];
  };
}
