{ config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vagrant.nix
    ./services
    ./variables.nix
  ];

  sops = {
    # Inserted via Vagrant
    age.keyFile = "/var/lib/sops-nix/keys.txt";
    defaultSopsFile = ./secrets.yaml;

    secrets = {
      "DOCKER_HUB_PAT" = { };
      "GCL_PROJ_1_CI_PROJECT_ID" = { };
      "GCL_PROJ_1_PATH" = { };
      "GITHUB_COM_TOKEN" = { };
      "GITLAB_COM_PAT" = { };
      "RENOVATE_BOT_RUNNER_PROJECT_ID" = { };
      "RENOVATE_TOKEN" = { };
    };

    templates."gitlab-ci-local/variables.yml" = {
      owner = config.users.users.developer.name;
      path = "${config.users.users.developer.home}/.gitlab-ci-local/variables.yml";

      content = ''
        ---
        global:
          CI_REGISTRY: ${config.nixbox.registryHost}
          CI_DEPENDENCY_PROXY_SERVER: docker.io
          # Default registry has no credential requirements, but we want a non-empty string
          CI_REGISTRY_USER: pigeonf
          CI_REGISTRY_PASSWORD: ${config.sops.placeholder."GITLAB_COM_PAT"}
          CI_DEPENDENCY_PROXY_USER: pigeonf
          CI_DEPENDENCY_PROXY_PASSWORD: ${config.sops.placeholder."DOCKER_HUB_PAT"}
          CI_DEPENDENCY_PROXY_GROUP_IMAGE_PREFIX: docker.io

        project:
          ${config.sops.placeholder."GCL_PROJ_1_PATH"}:
            CI_PROJECT_ID: ${config.sops.placeholder."GCL_PROJ_1_CI_PROJECT_ID"}
          gitlab.com/PigeonF/renovate-bot-runner:
            RENOVATE_TOKEN: ${config.sops.placeholder."RENOVATE_TOKEN"}
            GITHUB_COM_TOKEN: ${config.sops.placeholder."GITHUB_COM_TOKEN"}
            PRIVATE_TOKEN: ${config.sops.placeholder."RENOVATE_TOKEN"}
            CI_PROJECT_ID: ${config.sops.placeholder."RENOVATE_BOT_RUNNER_PROJECT_ID"}
      '';
    };
  };

  # Required to fix permissions of gitlab-ci-local folder
  #
  # https://github.com/Mic92/sops-nix/issues/381
  system.activationScripts = {
    gitlab-ci-local-folder.text = ''
      mkdir -p "${config.users.users.developer.home}/.gitlab-ci-local/"
      chown "${config.users.users.developer.name}:${config.users.users.developer.group}" "${config.users.users.developer.home}/.gitlab-ci-local/"
    '';
  };

  networking = {
    firewall.enable = false;
  };

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        bip = "10.117.0.1/16";
        default-address-pools = [
          {
            base = "10.118.0.0/16";
            size = 24;
          }
        ];
      };
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
