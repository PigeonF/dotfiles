{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vagrant.nix
    ./services
  ];

  sops = {
    # Inserted via Vagrant
    age.keyFile = "/var/lib/sops-nix/keys.txt";
    defaultSopsFile = ./secrets.yaml;

    secrets."CI_JOB_TOKEN" = { };

    templates."gitlab-ci-local/variables.yml" = {
      owner = config.users.users.developer.name;
      path = "${config.users.users.developer.home}/.gitlab-ci-local/variables.yml";

      content = ''
        ---
        global:
          CI_REGISTRY_USER: "nobody"
          CI_REGISTRY_PASSWORD: "nobody"
          CI_DEPENDENCY_PROXY_GROUP_IMAGE_PREFIX: docker.io
          CI_JOB_TOKEN = "${config.sops.placeholder.CI_JOB_TOKEN}"
      '';
    };
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];

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
    users.root = {
      hashedPassword = "!";
    };

    groups.developer = {
      name = "developer";
      members = [ "developer" ];
    };

    users.developer = {
      description = "Developer";
      name = "developer";
      group = "developer";
      extraGroups = [
        "users"
        "wheel"
        "docker"
      ];
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
