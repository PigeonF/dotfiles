{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.pigeonf.docker;
in
{
  options = {
    pigeonf.docker = {
      enable = lib.mkEnableOption "Enable docker";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        daemon.settings = {
          features = {
            containerd-snapshotter = true;
          };
          dns = [ "10.117.0.1" ];
          seccomp-profile =
            let
              moby = builtins.fetchGit {
                url = "https://github.com/moby/moby.git";
                ref = "master";
                rev = "ceefb7d0b9c5b6fbd1ea7511592a4ddb28ec4821";
              };
              mobySeccomp = builtins.fromJSON (builtins.readFile "${moby}/profiles/seccomp/default.json");

              buildkitSeccompJson = builtins.toJSON (
                mobySeccomp
                // {
                  syscalls = mobySeccomp.syscalls ++ [
                    {
                      names = [
                        "clone"
                        "keyctl"
                        "mount"
                        "pivot_root"
                        "sethostname"
                        "umount2"
                        "unshare"
                      ];
                      action = "SCMP_ACT_ALLOW";
                    }
                  ];
                }
              );
            in
            pkgs.writeText "seccomp.json" buildkitSeccompJson;
        };
      };
    };

    services.dnsmasq.settings.interface = [ "docker0" ];
    systemd.services.dnsmasq = {
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
    };
  };
}
