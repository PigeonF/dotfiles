{ pkgs, ... }:

{
  home = {
    packages = [ pkgs.rustup ];

    shellAliases = {
      c = "cargo";
    };

    sessionVariables = {
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    };

    sessionPath = [ "$CARGO_HOME/bin" ];
  };
}
