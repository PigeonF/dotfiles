{ inputs, ... }:

{
  flake.nixosModules.coruscant =
    { pkgs, ... }:
    {
      imports = [
        inputs.nixos-wsl.nixosModules.wsl

        inputs.self.nixosModules.core
        inputs.self.nixosModules.coreLinux
        inputs.self.nixosModules.home-manager
        inputs.self.nixosModules.nix
        ../../users/pigeon.nix
        inputs.self.nixosModules.vsCodeRemoteSSHFix
      ];

      networking.hostName = "coruscant";

      wsl = {
        enable = true;
        defaultUser = "pigeon";
      };

      environment.defaultPackages = [
        (pkgs.writeShellApplication {
          name = "relay-openssh-agent";

          runtimeInputs = [ pkgs.socat ];

          text = ''
            mkdir -p /mnt/d/tmp

            export SSH_AUTH_SOCK=/mnt/d/tmp/ssh-agent.sock
            ALREADY_RUNNING=$(pgrep -f "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; true)
            if [[ -z "$ALREADY_RUNNING" ]]; then
                if [[ -S $SSH_AUTH_SOCK ]]; then
                    echo "removing previous socket..."
                    rm $SSH_AUTH_SOCK
                fi
                echo "Starting SSH-Agent relay..."
                (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
            else
                echo "SSH-Agent relay is already running: $ALREADY_RUNNING"
            fi
          '';
        })
      ];
    };
}
