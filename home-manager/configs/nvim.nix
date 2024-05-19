{
  pkgs,
  config,
  inputs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    package = inputs.nixos-unstable-small.legacyPackages.${pkgs.system}.neovim-unwrapped;

    viAlias = true;
    vimAlias = true;

    defaultEditor = true;
  };

  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        clang
        emmet-ls
        hadolint
        markdownlint-cli
        nixfmt-rfc-style
        stylua
        unzip
        vale
        wget
        yaml-language-server
        zig
        ;

      inherit (pkgs.nodePackages) jsonlint typescript-language-server vscode-json-languageserver;
    };
  };

  xdg.configFile = {
    "nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/git/github.com/PigeonF/dotfiles/dotfiles/nvim/init.lua";
    "nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/git/github.com/PigeonF/dotfiles/dotfiles/nvim/lua";
    "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/git/github.com/PigeonF/dotfiles/dotfiles/nvim/lazy-lock.json";
  };
}
