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
    config =
      let
        locals = pkgs.writeText "haproxy-local-backends.map" ''
          rc4.xyz internal-reverse-proxy
          fierlings.family serenno
        '';
        proxied = pkgs.writeText "haproxy-local-proxies.map" ''
          attic.rc4.xyz attic.rc4.xyz
        '';
      in
      ''
        global
          log "/dev/log" len 65535 format "rfc3164" daemon info err
          maxconn 4096
          ssl-default-bind-ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256
          ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

        defaults
          log global
          option dontlognull
          option tcplog
          timeout client 30s
          timeout connect 5s
          timeout server 30s

        crt-store https
          crt-base /var/lib/acme
          key-base /var/lib/acme
          load crt "rc4.xyz/cert.pem" key "rc4.xyz/key.pem" alias "rc4.xyz"

        frontend http-redirect
          bind ipv4@:80
          bind ipv6@:80
          mode http
          option httplog
          redirect scheme https code 301

        frontend https-routing
          bind ipv4@:443
          bind ipv6@:443
          mode tcp
          tcp-request inspect-delay 5s
          tcp-request content capture req.ssl_sni len 256
          tcp-request content accept if { req_ssl_hello_type 1 }
          log-format "''${HAPROXY_TCP_LOG_FMT} {%[capture.req.hdr(0)]}"
          use_backend %[capture.req.hdr(0),lower,map_dom(${locals})]
          default_backend not-found

        backend serenno
          mode tcp
          server serenno serenno.incus:443 check port 80 send-proxy

        backend internal-reverse-proxy
          mode tcp
          server reverse-proxy 127.0.0.1:9443 send-proxy

        frontend reverse-proxy
          bind ipv4@127.0.0.1:9443 accept-proxy ssl crt "@https/rc4.xyz"
          bind ipv6@::1:9443 accept-proxy ssl crt "@https/rc4.xyz"
          mode http
          option httpslog
          use_backend %[req.hdr(Host),lower,map(${proxied})]
          default_backend not-found

        backend not-found
          mode http
          http-request deny deny_status 400

        backend attic.rc4.xyz
          mode http
          server attic 127.0.0.1:1234 check
      '';
  };

  services.atticd = {
    enable = true;
    settings = {
      api-endpoint = "https://attic.rc4.xyz/";
      listen = "[::]:1234";
    };
    environmentFile = (
      pkgs.writeText "attic.env" ''
        ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64="LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBNW96TzlNWVhrYkZQYWtrNFpxbHhXU1NMMGN3SFdOVFB2VGhya1B0Y2tySjY2K3U4Cm5pUkRkbGh2SjlxRW1xR1hnYlROWkd2bUQzUVQ1RmM4V0NlWXFYZGNoQlloTjdxU0dDR2RBRFpsOTRhQlhwYmMKWi9GZFVEUXBpQ3FKYWpQRW9rZi9raHZwTU1iNDVEYjcyd1ZKTVRNZ3RqZEpZd3VFRDZZMHN3QTNWdCtZTlkxVwpoK3JLckNmeFBxblk2WDRsZFRVVG1IbmhYNE5rL003Y3IvcDJlczBVdE9TNnR0bklCYUY0VU5tQWtOTDl1U2xzCm9pOFdFdTVoTTFoZGVqU2crdW9aTzNPcEo4RmhiYUxVemFhUzZpTEpCR0s5Y3RHb2I0ZUcwTVVjaEZtRzhEMWMKajk5U2xKYVRKVDAzeTR4K3JKYyt1QzJUOHhtQ2ZJKytwYjUxUGs0RU1vQ0pBdDI5RUNOdUR4dnlwV01vYmVQNgpISUpYNUZPVndaZFBtVytpL1hPRjFXcHltRHFITkNhU081U1JWL2ExdnBNb3pwOTBYWndNbHVrcmlmT2djOE9tCnk0SHAxa25PK3E0S0wzeG9kcmxmMm50U1A3MkJGQlBBZWkrTlB4TytkZFZKNWhic1k5cG05QzF1dnVqOWlZeFUKNEl0elFJVDY1Yy93aG0xaFM1TFJqRk1qWFY1anVldENQSXZPbHQyUmVUazlFQ0l6REtpdWtyKzFwUVFKUkNlLwp4REpMSGhidUFMeDZJMDlmbGJ3QndNWklsL1VzU0RyWFVCK0UzSTdlU1RMZjJoUmx0ZVJZVWNoMVFkZ3ppUzFSCnFraFh5aE5XcnVZRnZBWVZlbFJMVWIvRzlFNkF1cUgzVkluSFd6Q1FUMERPKzg1ZkpLTDFRK0YxZmlzQ0F3RUEKQVFLQ0FnQUJVNFFKUW01MlJ4ZlcyNjc0WURjbnRSOGN5Tml0K1NOc3lqdE1MVFgrSGdxNCtyVXVEN1ZYby9DWAp3UmtNTHF2SmNqblFQeEttdWhzM01BMUgwSXAvUnhHQUxRUnA1cWZhZmE4Q2hrMlYyKzg0bFJPVmdYenc3aXZpCi9hT211YitDMDNrejVQYzFjWitTNklJUVkzcGxUdzc4SFZ0TnQ0NDk3TTNXemNTRHVtdU11MUJwSGIrbXQrQWEKWlMyN1FoK0RDaGdmdzJ1NWVlOEZ5VWJadUU0Z0xMZld4bzRRYVRaT1dmeHdNcUFidFNzQ2VxdUdUMUVJTU5qYwpTOERWNkNHWTcrblBQcjRWWFhackJBbkhXUkwxUjlmeUw0TTVldDFHTHZobWtRdTE4ekhraGVYWGFnaDJsRnNxClZxelFmZkZvbXNJZ214cUR4bnpLcktVREhSSmRrNWVmYWdIV0NaM2lsN1Y1UEVVMEZxUnVtVlVMc0wrNW1razkKWU5yaDBlZkhRUFN0ajl2bExmQTRsRVA5MjZ5d1BXVUtNZ1hpZ0QxYlZwUC9ybitVeXArcytKa0hYaVZRMHFTNQo5emlpT1FTZ0FGenduVGE2OXVNK3hPbnZEKzJ3V01ZV05DY0wxUVQvOGlMOWVTRTdsQ2h5dFdLeUJMcDZuWnBnCnNJTXUxTlpTMUNnZ3hRS0VFRThYLzJadDlxTk5TUkJnN01EN2xsVXFycTVOY3FQTkF2OHVvbUV4am5peVFMelMKSUkrU0RYLy82V3Nxd0Qvd1RKVE84YWVxYmY1cmgxeEhFNW9WWndJMlZLZVJQTEVkNU95UFQrNUVjVTR3YlRkWQpwa1J2ZW1YUWIvczM4aXU2STlWc2t0dkRkUUFiV3VpVWFCRTZRU3Y2N05DL3dwaTMwUUtDQVFFQStBQnlCa3V2Cnc4cHZhdWlyY21SU1lTQ0NUWkl0NGM0T3ZrN2FWVWpZU2JUNlhXOEtBMjM4bXRXUFFkSmRNTjRIS0lYazY3VnIKSWZXVFR0N1AzbFpsMWRveFNmUExJc2RRcHNHZFViUHFGQTFvTmpVY1ptNko3U3ZqdDdHR2hZQXF0Snd0V2xjOQpLcHJsVHJKbmpJR1c5ME5paFI3Sm9CdWtTeERXWWtCakVWMWtNWnBuS2Z0bE5SWjFaK0J4T2VEVVk5MUxER2d6CjlRdlRSQjBUaFJXZTZqVzVoY1NmMmd6SVhQNEN2Yy9nYVNnanQvZVRtWEZRVngrdVpETDM0dTd1UFJQVENodk8KKzNnaUxUYUpiSHNDWWZ6VC92djlyc0lzMTJwU2YvMTk2Q1ZHZEZCaEFuNkx6ZmZ5QzNFanVDT1RkaEc0M1kvdQptY2hwM1hnVW9teU5jd0tDQVFFQTdmeEhMZ1JCSTRIRG9MV2pxcDJ5MjZhbktnQUYycWQ1T2JaK251RHkzTjJiClgzam5qc1Z1UGFPMk4rSnFmOWxtZW5sM0ptQ3kycDc5OC82L1BEbHhZMlljUTJBdWJad1hxTXBubFBoQzdZMUsKOUp0NndIUTV6dFVWRnY5Wm5WRjU2Z3MxKzh2MjkvbnJ4NEUwODBwaUU2bEVWeEIzdkNaOFFXTnBJeFJuUUJHMgpLWkFtYk4zblRkMEVXUDI2VEZEenpCaXZ5R1ZEMnlma25aNVB2Q2RqOGs5ZzFGamt2ZTIzTnRUc0ZKbU1NREpwCmxVMUphWHlZRWhmSnZHeWJBNlhmaDVFZ0FKZm5DNXZjZHJFaWZ3d3ZJdy9YZXF4V3ByeUFjRjBzY3VCYUVqSXUKbE5jQUY5RmRRYTNhdXZheXJVUjQ4dVpFZG9JTytLeGtxK2dWTlRRZWFRS0NBUUJDMk5QalVJbGE2L2ptUnpyWApSYVZTMnRGa21VOVd1eFVNUlBMaTVCU3dvV0NPeUx4Wk9rOUphT0VKYSt1RW5ZUXVieERLWEFjNWl4a2V2RDRwCmZ2NUtDMXNYeE9mdlF1eEJWcFRTRGYyOVUvUFFFTGJNQVdXYUVTZDdQeFcwYkZ5V2ZEWlpVSVNETkdjMHRDL24KRnBNYnFRVW9QcWs0UjlzY0JMalVtT2hiS09JMTRKbUlIbVFrVUI1clZuc09qOFNQK25rZEtnVS9PdVhDU1ZnVwpta0pRZlJTNXNzc25taVJ6dEdBR3k3NkFlYnBPL3lQQXkyTk5hSk80SEdqbXVXSnNBaWp6WTVXQ0FOcXRkekxKCms4cUxvUHQva21ySnJUc3JBVlNsZlMxdjRvUkFHOTVhTHNQK1M2UHBZNkN1SktDOXhYOGY4WWp0MkxCNGFzS2QKR1VkekFvSUJBUUNNcWFBb3dycjlrYVZmUi8wRXkxRDhJdlNMRHBobk5MV2lOd3VBUE5WUFZteVBjWmJyL0NXOApxUmI2MFFqQnFHMjUxakZtcmFFSk54QkROejh4Q1lMTGpYOEhFOEpkWnZWVS9zMWFiNktmWmZQM3dDNDlzblM0Cm01bHJqbUlaYWg3MUJzdFJtS3pReFJkblJDZFg1WTh5cjhtRTdHYlkvcVpTdjc5VXpLcDZZLzJYYzJ4Q3pLWDYKajdnU0lXWUwxWTFFQlJOaER2bWNmMmZSQWRGL0ZJa3VuMXhNSm42TkJBUldsR00xaWN3aWNLbVhaYWNPZ21ZZgp5NCtobjAvQVNEcG1scENqeVNUMjU1alhUcnRrL0g2ZjZxMGlCTnJ5a2xnWUVmcERxL2VRNmJnK29SV2MvbEp3Cmo2SEpBQ2Q3NGd6YkJOOVNiRzBNN2xoU2cwcUZ0OWlCQW9JQkFRRHpzYW1QL1FwekZhZE5JNkRCcURPR1pUMXgKck1wV3hCSDRJZE9lL01hNjdHajFmanh3ZmhHcjV0U3Z1a1RId2JmVGRXQmVpNmMyK2NUR3ZCOG9oTm9mTnFFbQpIUW04STZhNmVHbkNpcExuaThveHMzZGo1TGJOVjlqT1pxYldweDc5aEhaZHRLNHVEeitVL1lzUVJZYVdvaURUCmNFZGhscWhKTW51dTNsdmdDSy9uallhV0JYNnpuVlkxN3ZDd3JuSDQwODluVGhtbnRwbGtUdnZXNUZGWWtHQmkKOE0yV0EyUno1czdYSkpPTEIyTGlOaDNkMUR4RVVic3ErT0ZOdlB5cGNtYnRHMVNRdlNTbjZTU3BNRTJtd3ZlNwpnQXZLWEtxQmwzYlZ1bkZhUUhLbkZZVkxSNHlFajRxM3BkbU0zZjJqaFBwdE0rQWVjMmJUQ3FIeXMxcEkKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K"
      ''
    );
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
      enable = false;
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
