{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.zellij;
in
{
  _file = ./zellij.nix;

  options.dotfiles.programs = {
    zellij = {
      enable = mkEnableOption "set up zellij";
    };
  };

  config = lib.mkMerge [
    {
      programs = {
        zellij = {
          inherit (cfg) enable;
          enableBashIntegration = false;
          enableFishIntegration = false;
          enableZshIntegration = false;
        };
      };
    }
    (lib.mkIf cfg.enable {
      programs = {
        bash = {
          initExtra = ''
            # Refresh the SSH_AUTH_SOCK variable from within zellij
            # See <https://github.com/zellij-org/zellij/issues/1637>
            function zellij-refresh-ssh-sock() {
              if [ -n "$ZELLIJ" ]; then
                if SSH_AUTH_SOCK=$(find "$HOME/.ssh/agent" -type s -exec ls -1rt "{}" + | head -n 1); then
                  export SSH_AUTH_SOCK
                fi
              fi
            }
          '';
        };
      };
    })
  ];
}
