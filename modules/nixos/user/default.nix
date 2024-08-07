{ config, lib, ... }:
let
  cfg = config.pigeonf.user;
in
{
  _file = ./default.nix;

  options = {
    pigeonf.user = {
      enable = lib.mkEnableOption "PigeonF User Account";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.pigeonf = {
        name = "pigeonf";
        members = [ "pigeonf" ];
      };

      users.pigeonf = {
        description = "Developer Account";
        name = "pigeonf";
        group = "pigeonf";
        extraGroups =
          [
            "users"
            "wheel"
          ]
          ++ lib.lists.optional config.virtualisation.docker.enable "docker"
          ++ lib.lists.optional config.virtualisation.podman.enable "podman"
          ++ lib.lists.optional config.virtualisation.lxd.enable "lxd"
          ++ lib.lists.optional config.virtualisation.incus.enable "incus-admin";
        home = "/home/pigeonf";
        createHome = true;
        useDefaultShell = true;
        isNormalUser = true;
        initialPassword = "pigeonf";
        openssh.authorizedKeys.keys = lib.mkForce [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
        ];
      };
    };

    systemd.services."user@".serviceConfig.Delegate = "cpu io memory pids cpuset";

    nix.settings.trusted-users = [ "pigeonf" ];
  };
}
