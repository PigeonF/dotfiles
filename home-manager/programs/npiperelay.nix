{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    ;
  cfg = config.dotfiles.programs.npiperelay;
in
{
  _file = ./npiperelay.nix;

  options.dotfiles.programs = {
    npiperelay = {
      enable = mkEnableOption "set up npiperelay";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs = {
        bash = {
          initExtra = ''
            export SSH_AUTH_SOCK=$HOME/.ssh/ssh-agent.sock

            SSH_AGENT_WORKING=$(ssh-add -l >/dev/null 2>&1; echo $?)
            if [[ $SSH_AGENT_WORKING != "0" ]]; then
                kill $(ps -auxww | grep "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent" | awk '{print $2}') >/dev/null 2>&1
            fi

            ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
            if [[ "$ALREADY_RUNNING" != "0" ]]; then
                if [[ -S "$SSH_AUTH_SOCK" ]]; then
                    rm -f "$SSH_AUTH_SOCK" >/dev/null 2>&1
                fi
                (setsid socat "UNIX-LISTEN:$SSH_AUTH_SOCK,fork" EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
            fi
          '';
        };
      };
      # home = {
      #   packages = [ pkgs.windows.npiperelay ];
      # };
    })
  ];
}
