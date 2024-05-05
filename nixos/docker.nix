{ pkgs, lib, ... }:
{
  virtualisation = {
    oci-containers.backend = "docker";

    docker = {
      enable = true;
      daemon.settings = {
        bip = "10.117.0.1/16";
        ip = "127.0.0.1";
      };
    };
  };

  systemd.services."docker-network-dev" = {
    serviceConfig.Type = "oneshot";
    script = lib.getExe (
      pkgs.writeShellApplication {
        name = "docker-create-dev-network";

        runtimeInputs = [ pkgs.docker ];

        text = ''
          docker network inspect dev > /dev/null 2>&1 || \
          docker network create dev --subnet 10.118.0.0/24
        '';
      }
    );
    postStop = "${lib.getExe pkgs.docker} network rm -f dev";
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];
}
