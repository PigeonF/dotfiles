{ pkgs, ... }:

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
        stylua
        unzip
        wget
        zig
        ;
    };
  };

  xdg.configFile = {
    "nvim/init.lua".source = ../../dotfiles/nvim/init.lua;
    "nvim/lua".source = ../../dotfiles/nvim/lua;
    "nvim/lazy-lock.json".source = ../../dotfiles/nvim/lazy-lock.json;
  };
}
