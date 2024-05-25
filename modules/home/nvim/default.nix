{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.pigeonf.nvim;
  inherit (lib) mkIf mkEnableOption;
in
{
  _file = ./default.nix;

  options.pigeonf.nvim = {
    enable = mkEnableOption "PigeonF NeoVim Packages";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        clang
        emmet-ls
        fzf
        hadolint
        lua-language-server
        markdownlint-cli
        nixfmt-rfc-style
        skim
        stylua
        unzip
        vale
        wget
        yaml-language-server
        zig
        ;

      inherit (inputs.nixos-unstable-small.legacyPackages.${pkgs.system}) neovim-unwrapped;

      inherit (pkgs.nodePackages) jsonlint typescript-language-server vscode-json-languageserver;
    };
  };
}
