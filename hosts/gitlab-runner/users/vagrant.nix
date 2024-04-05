{ stateVersion }:
{
  imports = [
    ../../../dotfiles/git
    ../../../dotfiles/just
  ];

  home = {
    inherit stateVersion;
  };
}
