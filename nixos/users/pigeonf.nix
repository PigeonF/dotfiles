{ config, lib, ... }:
{
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

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "pigeonf" ];
  };

  nix.settings.trusted-users = [ "pigeonf" ];
}
