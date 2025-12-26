let
  username = "reviewer";
in
{
  _file = ./reviewer.nix;

  dotfiles = {
    dotter = {
      enable = true;
      clone = {
        enable = false;
      };
    };
    presets = {
      shell = {
        enable = true;
      };
    };
    programs = {
      atuin.enable = true;
      bash.enable = true;
      bat.enable = true;
      eza.enable = true;
      fd.enable = true;
      git.enable = true;
      ghq.enable = true;
      helix.enable = true;
      home-manager.enable = true;
      jujutsu.enable = true;
      nix.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      vivid.enable = true;
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
