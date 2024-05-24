{
  inputs,
  config,
  lib,
  ...
}:
{
  home-manager.users.pigeon = inputs.self.homeModules.users.pigeon;

  users = {
    groups.pigeon = {
      name = "pigeon";
      members = [ "pigeon" ];
    };

    users.pigeon = {
      description = "Developer Account";
      name = "pigeon";
      group = "pigeon";
      extraGroups =
        [
          "users"
          "wheel"
        ]
        ++ lib.lists.optional config.virtualisation.docker.enable "docker"
        ++ lib.lists.optional config.virtualisation.podman.enable "podman"
        ++ lib.lists.optional config.virtualisation.lxd.enable "lxd"
        ++ lib.lists.optional config.virtualisation.incus.enable "incus-admin";
      home = "/home/pigeon";
      createHome = true;
      useDefaultShell = true;
      isNormalUser = true;
      initialPassword = "pigeon";
      openssh.authorizedKeys.keys = lib.mkForce [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
      ];
    };
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "pigeon" ];
  };

  nix.settings.trusted-users = [ "pigeon" ];
}
