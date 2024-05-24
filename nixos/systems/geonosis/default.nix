{ config, inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    inputs.self.nixosModules.gitlab-runner
    inputs.self.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    ../../../shared/core.nix
    ../../../shared/nix.nix

    ../../core.nix
    ../../docker.nix
    ../../dockerRegistry.nix
    ../../webservices.nix
    ../../laptop.nix
    ../../network.nix
    ../../ssh.nix
    ../../users/pigeon.nix

    ./disk.nix
  ];

  sops.secrets."network" = {
    sopsFile = ./network.env;
    format = "dotenv";
    restartUnits = [ "wpa_supplicant.service" ];
  };

  sops.secrets."gitlab-runner/environment" = {
    sopsFile = ./gitlab-runner-default.env;
    format = "dotenv";
    restartUnits = [ "gitlab-runner.service" ];
  };

  pigeonf.gitlabRunner = {
    enable = true;
    privileged = true;
    envFile = config.sops.secrets."gitlab-runner/environment".path;
  };

  virtualisation.incus.enable = true;
  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  services.dnsmasq.settings = {
    interface = [
      "docker0"
      "wlp61s0"
    ];
    bind-interfaces = true;
    address = [ "/incus/10.109.165.1" ];
  };

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

  boot = {
    initrd.availableKernelModules = [ "nvme" ];
    kernelModules = [
      "kvm-intel"
      "iwlwifi"
    ];

    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}
