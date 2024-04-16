{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    defaultEditor = true;
  };

  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        clang
        hadolint
        markdownlint-cli
        stylua
        unzip
        vale
        wget
        zig
        ;

      inherit (pkgs.nodePackages) jsonlint;
    };
  };

  xdg.configFile = {
    "nvim/init.lua".source = ../../dotfiles/nvim/init.lua;
    "nvim/lua".source = ../../dotfiles/nvim/lua;
    "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/git/github.com/PigeonF/dotfiles/dotfiles/nvim/lazy-lock.json";
  };
}
