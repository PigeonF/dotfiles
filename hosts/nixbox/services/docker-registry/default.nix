{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs-networking.lib) ipv4;
in
{
  sops.secrets."dockerRegistry/certificateKey" = {
    sopsFile = ./local-registry.gitlab.com/key.pem.age;
    format = "binary";
    restartUnits = [ "docker-registry.service" ];
    mode = "0440";

    owner = config.users.users.docker-registry.name;
    inherit (config.users.users.docker-registry) group;
  };

  services.dockerRegistry =
    let
      docker0 = ipv4.cidrToFirstUsableIp config.virtualisation.docker.daemon.settings.bip;
    in
    {
      enable = true;
      package = pkgs.gitlab-container-registry;
      enableDelete = true;
      enableGarbageCollect = true;
      listenAddress = ipv4.prettyIp docker0;

      extraConfig = {
        http = {
          tls = {
            # nix run nixpkgs#minica -- -ip-addresses 10.117.0.1
            certificate = ./local-registry.gitlab.com/cert.pem;
            key = "/run/secrets/dockerRegistry/certificateKey";
          };
        };
      };
    };

  # Since we bind to docker0 address, make sure it is available first.
  systemd.services.docker-registry.after = [
    "network.target"
    "docker.service"
  ];

  system.activationScripts = {
    # Because we mount the whole certs.d folder, we cannot have smylinks inside it, which means we
    # cannot use `environment.etc` to create the file.
    docker-registry-certs-d.text = ''
      mkdir -p /etc/docker/certs.d/${config.nixbox.registryHost}/
      rm -f /etc/docker/certs.d/${config.nixbox.registryHost}/ca.crt
      cp -L ${./minica.pem} /etc/docker/certs.d/${config.nixbox.registryHost}/ca.crt
    '';
  };
}
