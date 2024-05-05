{
  inputs,
  config,
  lib,
  ...
}:
{
  home-manager.users.vagrant = inputs.self.homeModules.users.vagrant;

  users = {
    groups.vagrant = {
      name = "vagrant";
      members = [ "vagrant" ];
    };

    users.vagrant = {
      description = "Developer Account";
      name = "vagrant";
      group = "vagrant";
      extraGroups =
        [
          "users"
          "wheel"
        ]
        ++ lib.lists.optional config.virtualisation.docker.enable "docker"
        ++ lib.lists.optional config.virtualisation.podman.enable "podman"
        ++ lib.lists.optional config.virtualisation.virtualbox.guest.enable "vboxsf";
      home = "/home/vagrant";
      createHome = true;
      useDefaultShell = true;
      isNormalUser = true;
      hashedPassword = "!";
      openssh.authorizedKeys.keys = lib.mkForce [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
      ];
    };
  };

  nix.settings.trusted-users = [ "vagrant" ];
}
