{ inputs, ... }:

{
  flake.nixosModules.geonosis =
    { config, ... }:
    {
      imports = [
        inputs.self.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko

        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s

        inputs.self.nixosModules.core
        inputs.self.nixosModules.coreLinux
        inputs.self.nixosModules.docker
        inputs.self.nixosModules.dockerRegistry
        inputs.self.nixosModules.laptop
        inputs.self.nixosModules.network
        inputs.self.nixosModules.nix
        inputs.self.nixosModules.pigeon
        inputs.self.nixosModules.ssh
        inputs.self.nixosModules.vsCodeRemoteSSHFix
        inputs.self.nixosModules.webservices
        inputs.self.nixosModules.gitlab-runner
        ./disk.nix
      ];

      sops.secrets."network" = {
        sopsFile = ./network.env;
        format = "dotenv";
        restartUnits = [ "wpa_supplicant.service" ];
      };

      pigeonf.gitlabRunner.privileged = true;
      sops.secrets."gitlab-runner/environment" = {
        sopsFile = ./gitlab-runner-default.env;
        format = "dotenv";
        restartUnits = [ "gitlab-runner.service" ];
      };

      networking.hostName = "geonosis";
      networking.wireless = {
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
    };
}
