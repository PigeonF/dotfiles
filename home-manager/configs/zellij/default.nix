{ config, ... }:

{
  programs.zellij = {
    enable = true;
    # Because of https://github.com/nix-community/home-manager/issues/4613, we
    # do not generate the configuration via nix.
  };

  xdg.configFile =
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      dotfiles = "${config.home.homeDirectory}/git/github.com/PigeonF/dotfiles";
    in
    {
      "zellij/config.kdl" = {
        source = mkOutOfStoreSymlink "${dotfiles}/home-manager/configs/zellij/config.kdl";
      };
      "zellij/layouts/terminal.kdl" = {
        source = mkOutOfStoreSymlink "${dotfiles}/home-manager/configs/zellij/layouts/terminal.kdl";
      };
    };
}
