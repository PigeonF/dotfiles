let
  username = "root";
in
{
  _file = ./root.nix;

  dotfiles = {
    presets = {
      shell.enable = true;
    };
    programs = {
      atuin.enable = true;
      bash.enable = true;
      bat.enable = true;
      btop.enable = true;
      docker.enable = true;
      eza.enable = true;
      fd.enable = true;
      fzf.enable = true;
      home-manager.enable = true;
      nix.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      vivid.enable = true;
      zoxide.enable = true;
    };
  };
  home = {
    inherit username;
    homeDirectory = "/root";
    stateVersion = "25.11";
  };
  news = {
    display = "silent";
  };
}
