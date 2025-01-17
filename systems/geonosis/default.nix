{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  _file = ./default.nix;

  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    inputs.self.nixosModules.default
    inputs.quadlet-nix.nixosModules.quadlet
    inputs.sops-nix.nixosModules.sops

    # ./acme.nix
    # ./haproxy.nix
    ./hardware.nix
    # ./paperless.nix
    ./secrets
    ./incus.nix
  ];

  system.stateVersion = "24.05";
  networking.hostName = "geonosis";

  networking = {
    nat = {
    };
    firewall.allowedTCPPorts = [
      80
      8080
      443
      4443
    ];
  };

  nix = {
    settings = {
      trusted-public-keys = [ "alice:R++4LTYSvoZ5PpnvzJ5FjiTaWHcnUoOndTt6gAu269w=" ];
      # extra-substituters = [ "ssh-ng://alice" ];
    };
  };

  services.haproxy = {
    enable = true;
    config = ''
      global
        # Process management and security
        # fd-hard-limit 32768
        log "/dev/log" len 65535 format "rfc3164" daemon info err
        # Performance tuning
        maxconn 16384

      defaults
        option dontlognull
        log global
        timeout client 30s
        timeout server 30s
        timeout connect 5s

      frontend http-redirect
        bind *:80,:::80 v6only
        mode tcp
        option tcplog
        use_backend serenno-80

      frontend https
        bind *:443,:::443 v6only
        mode tcp
        option tcplog
        tcp-request inspect-delay 10s
        tcp-request content accept if { req_ssl_hello_type 1 }
        use_backend serenno-443

      backend serenno-80
        mode tcp
        server serenno serenno.incus:80

      backend serenno-443
        mode tcp
        server serenno serenno.incus:443
    '';
  };

  environment.systemPackages = [
    pkgs.mako
    pkgs.wl-clipboard
    # https://kokada.capivaras.dev/blog/quick-bits-realise-nix-symlinks/
    (pkgs.writeShellApplication {
      name = "realise-symlink";
      runtimeInputs = with pkgs; [ coreutils ];
      text = ''
        for file in "$@"; do
          if [[ -L "$file" ]]; then
            if [[ -d "$file" ]]; then
              tmpdir="''${file}.tmp"
              mkdir -p "$tmpdir"
              cp --verbose --recursive "$file"/* "$tmpdir"
              unlink "$file"
              mv "$tmpdir" "$file"
              chmod --changes --recursive +w "$file"
            else
              cp --verbose --remove-destination "$(readlink "$file")" "$file"
              chmod --changes +w "$file"
            fi
          else
            >&2 echo "Not a symlink: $file"
            exit 1
          fi
        done
      '';
    })
  ];

  virtualisation.containerd.enable = true;
  virtualisation.docker.daemon.settings = {
    features = {
      "containerd-snapshotter" = true;
    };
    "insecure-registries" = [
      "registry.internal"
      "registry.internal:80"
    ];
  };

  # services.gnome.gnome-keyring.enable = true;
  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };
  # programs.firefox.enable = true;

  systemd.services.iwd = {
    bindsTo = [ "systemd-networkd.service" ];
    after = [ "systemd-networkd.service" ];
  };

  boot.initrd.systemd.enable = true;

  networking = {
    useDHCP = false;
    networkmanager.enable = false;
    dhcpcd.enable = false;
    nftables.enable = true;

    wireless = {
      enable = false;

      iwd = {
        enable = false;
        settings = {
          Scan.DisablePeriodicScan = true;
          # General.UseDefaultInterface = true;
          General.EnableNetworkConfiguration = false;
          DriverQuirks = {
            DefaultInterface = "*";
          };
        };
      };
    };
  };

  services = {
    resolved.enable = true;
  };

  systemd = {
    network.enable = true;
    network.links."80-iwd".linkConfig.NamePolicy =
      lib.mkOverride 999 "keep kernel database onboard slot path";
  };

  systemd.network.networks = {
    "05-enp0s31f6" = {
      matchConfig = {
        Name = "enp0s31f6";
        Type = "ether";
      };
      address = [
        "192.168.178.123/24"
        "fd21:5e04::/64"
      ];
      gateway = [ "192.168.178.1" ];
      dns = [ "192.168.178.53" ];
      linkConfig = {
        RequiredForOnline = "routable";
      };
    };

    "10-uplink" = {
      matchConfig = {
        Name = "en* eth0";
        Type = "ether";
      };
      networkConfig = {
        DHCP = "yes";
      };
      linkConfig = {
        RequiredForOnline = "routable";
      };
    };
    "10-wireless" = {
      matchConfig = {
        Name = "wl*";
        Type = "wlan";
      };
      networkConfig = {
        DHCP = "yes";
      };
      linkConfig = {
        Unmanaged = "yes";
        RequiredForOnline = "no";
      };
    };
  };

  pigeonf = {
    attic = {
      enable = true;
      envFile = config.sops.secrets."attic".path;
    };

    kellnr = {
      enable = false;
      envFile = config.sops.secrets."kellnr".path;
    };

    buildkit.enable = true;
    container-registry.enable = true;
    core.enable = true;
    dns.enable = true;
    docker-rootless.enable = false;
    docker.enable = true;
    # guix.enable = true;
    incus.enable = true;
    nix.enable = true;
    podman.enable = true;
    # pypiserver.enable = true;
    user.enable = true;
    virtualisation.containers.registries.enable = true;

    # network = {
    #   enable = true;
    #   avahi.enable = true;
    #   envFile = config.sops.secrets."network".path;

    #   networks = {
    #     lan-solo.enable = true;
    #   };
    # };

    gitlab-runner = {
      enable = true;
      runners = {
        gitlab = {
          description = "gitlab.com Runner";
          envFile = config.sops.secrets."gitlab-runner-gitlab-com/environment".path;
          buildkitEnabled = true;
        };

        default = {
          description = "git.noc.rub.de Runner";
          envFile = config.sops.secrets."gitlab-runner-git-noc-rub-de/environment".path;
          buildkitEnabled = true;
        };
      };
    };
  };
}
