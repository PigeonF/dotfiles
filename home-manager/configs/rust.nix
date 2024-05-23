{ config, pkgs, ... }:

{
  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        cargo-audit
        cargo-auditable
        cargo-binutils
        cargo-bloat
        cargo-cross
        cargo-cyclonedx
        cargo-deny
        cargo-dist
        cargo-geiger
        cargo-hack
        cargo-llvm-cov
        cargo-nextest
        cargo-zigbuild
        rustup
        zig
        ;
    };

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
