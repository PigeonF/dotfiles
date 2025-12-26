let
  username = "user";
in
{
  _file = ./user.nix;

  dotfiles = {
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
    stateVersion = "25.11";
  };
  news = {
    display = "silent";
  };
}
