{ pkgs, lib, ... }:
{
  virtualisation = {
    oci-containers.backend = "docker";

    docker = {
      enable = true;
      daemon.settings = {
        bip = "10.117.0.1/16";
        ip = "127.0.0.1";
        default-address-pools = [
          {
            base = "10.118.0.0/16";
            size = 24;
          }
          {
            base = "10.119.0.0/16";
            size = 24;
          }
        ];
        registry-mirrors = [ "http://registry-cache.internal" ];
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
    preStop = lib.getExe (
      pkgs.writeShellApplication {
        name = "docker-create-dev-network";

        runtimeInputs = [ pkgs.docker ];

        text = ''
          docker network inspect dev --format '{{ range $k, $v := .Containers }}{{ printf "%s\n" $k }}{{ end }}' | while read -r container; do
            if [[ -z "$container" ]]; then
              continue
            fi

            docker network disconnect --force dev "$container"
          done
        '';
      }
    );
    postStop = "${lib.getExe pkgs.docker} network rm --force dev";
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];
}
