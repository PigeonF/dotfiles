_: {
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vagrant.nix
    ./services
  ];

  # Inserted via Vagrant
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";

  networking.firewall.trustedInterfaces = ["docker0"];

  virtualisation = {
    docker = {
      enable = true;
    };

    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # For VS Code server
  programs.nix-ld.enable = true;

  security.sudo.extraConfig = ''
    Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
    Defaults:root,%wheel env_keep+=NIX_PATH
    Defaults:root,%wheel env_keep+=TERMINFO_DIRS
    Defaults env_keep+=SSH_AUTH_SOCK
    Defaults lecture = never
    root   ALL=(ALL) SETENV: ALL
    %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
  '';

  networking.interfaces = {
    enp0s8.ipv4.addresses = [
      {
        address = "192.168.50.2";
        prefixLength = 24;
      }
    ];
  };

  users = {
    mutableUsers = false;
    # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235
    users.root = {hashedPassword = "!";};

    groups.developer = {
      name = "developer";
      members = ["developer"];
    };

    users.developer = {
      description = "Developer";
      name = "developer";
      group = "developer";
      extraGroups = ["users" "wheel" "docker"];
      password = "developer";
      home = "/home/developer";
      createHome = true;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
      ];
      isNormalUser = true;
    };
  };
}
