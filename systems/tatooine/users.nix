{
  _file = ./default.nix;

  nix.settings.trusted-users = [
    "@wheel"
    "remotebuild"
  ];

  security.sudo = {
    wheelNeedsPassword = false;
    execWheelOnly = true;
  };

  users.mutableUsers = false;

  users.users = {
    administrator = {
      isNormalUser = true;
      home = "/home/administrator";
      description = "Server Administrator";
      extraGroups = [
        "wheel"
        "systemd-journal"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrvH0nDk8x981CcsIvTYzYS2WUvG1JrgoZDEWZgCayz"
      ];
    };

    remotebuild = {
      isNormalUser = true;
      createHome = false;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYq9M8N4YUBhBvNuqoCEM4aGOHSiqax2OhZzNRVXNqo"
      ];
    };
  };
}
