{ config, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    inputs.self.nixosModules.default
    inputs.sops-nix.nixosModules.sops

    ./core.nix
    ./docker.nix
    ./dockerRegistry.nix
    ./laptop.nix
    ./network.nix
    ./nix.nix
    ./ssh.nix
    ./webservices.nix

    ./hardware.nix
    ./secrets
  ];

  pigeonf = {
    userAccount.enable = true;

    gitlabRunner = {
      enable = true;
      runners = {
        default = {
          description = "Default Runner";
          envFile = config.sops.secrets."gitlab-runner/environment".path;
        };

        privileged = {
          description = "Privileged Runner";
          envFile = config.sops.secrets."gitlab-runner/privileged/environment".path;
          privileged = true;
        };
      };
    };
  };

  virtualisation.incus.enable = true;
  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  services.dnsmasq.settings.address = [ "/incus/10.109.165.1" ];

  networking = {
    nftables.enable = true;

    hostName = "geonosis";

    wireless = {
      enable = true;
      userControlled.enable = true;
      environmentFile = config.sops.secrets."network".path;
      scanOnLowSignal = false;
      fallbackToWPA2 = false;

      networks = {
        "Obi-Lan Kenobi" = {
          psk = "@PASS_OBI_LAN_KENOBI@";
        };

        eduroam = {
          auth = ''
            key_mgmt=WPA-EAP
            eap=TTLS
            anonymous_identity="eduroam@ruhr-uni-bochum.de"

            identity="@USER_EDUROAM@@ruhr-uni-bochum.de"
            password="@PASS_EDUROAM@"

            phase2="auth=PAP"

            proto=RSN WPA
            mode=0
            pairwise=CCMP TKIP
            group=CCMP TKIP

            subject_match="/C=DE/ST=Nordrhein-Westfalen/L=Bochum/O=Ruhr-Universitaet Bochum/OU=Network Operation Center/CN=radius.ruhr-uni-bochum.de"
          '';
        };
      };
    };
  };
}
