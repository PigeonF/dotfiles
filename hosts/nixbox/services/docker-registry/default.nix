{ config, pkgs, ... }:
let
  # TODO(PigeonF): Wait for https://github.com/NixOS/nixpkgs/pull/258250 to land
  docker0IpAddress = "10.117.0.1";
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

  services.dockerRegistry = {
    enable = true;
    package = pkgs.gitlab-container-registry;
    enableDelete = true;
    enableGarbageCollect = true;
    listenAddress = docker0IpAddress;

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

  environment.etc = {
    "docker/certs.d/${config.nixbox.registryHost}/ca.crt" = {
      source = ./minica.pem;
    };
    "buildkit/buildkitd.toml" = {
      text = ''
        [registry."${config.nixbox.registryHost}"]
          ca=["/etc/docker/certs.d/${config.nixbox.registryHost}/ca.crt"]
      '';
    };
  };
}
