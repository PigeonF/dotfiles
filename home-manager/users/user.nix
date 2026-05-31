let
  username = "user";
in
{
  _file = ./user.nix;

  dotfiles = {
    dotter = {
      enable = true;
      clone = {
        enable = true;
      };
    };
    presets = {
      shell.enable = true;
    };
    programs = {
      atuin.enable = true;
      bash.enable = true;
      bat.enable = true;
      eza.enable = true;
      fd.enable = true;
      home-manager.enable = true;
      nix.enable = true;
      npiperelay.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      vivid.enable = true;
      zoxide.enable = true;
      zellij.enable = true;
    };
  };
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };
  news = {
    display = "silent";
  };
}
