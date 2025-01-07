# SPDX-FileCopyrightText: 2025 Jonas Fierlings <fnoegip@gmail.com>
#
# SPDX-License-Identifier: 0BSD
{
  pkgs,
  ...
}:
{
  _file = ./nixos.nix;

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  services.openssh = {
    enable = true;
  };

  system.stateVersion = "24.11";
  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
  ];

  nix.settings.trusted-users = [ "@wheel" ];

  security = {
    doas = {
      enable = true;
      wheelNeedsPassword = false;
    };
    sudo.enable = false;
  };

  users = {
    mutableUsers = false;

    users.pigeonf = {
      isNormalUser = true;
      description = "Server Administrator";
      extraGroups = [
        "wheel"
        "systemd-journal"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
      ];
    };
  };
}
