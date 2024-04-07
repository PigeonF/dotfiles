{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableNushellIntegration = false;
    nix-direnv.enable = true;
    config = {
      strict_env = true;
    };
    stdlib = ''
      : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(${pkgs.coreutils}/bin/sha1sum - <<< "$PWD" | ${pkgs.coreutils}/bin/head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
      }
    '';
  };
}
