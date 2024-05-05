{
  virtualisation = {
    oci-containers.containers."registry.internal" = {
      image = "docker.io/registry";
      ports = [
        "127.0.0.1:5000:80"
        "[::1]:5000:80"
      ];
      environment = {
        REGISTRY_HTTP_ADDR = "0.0.0.0:80";
      };
      extraOptions = [ "--network=dev" ];
    };

    docker.daemon.settings."insecure-registries" = [ "registry.internal" ];
  };

  services.nginx.virtualHosts."registry.internal".locations."/" = {
    proxyPass = "http://127.0.0.1:5000/";
    extraConfig = ''
      client_max_body_size 0;
    '';
  };

  systemd.services."docker-network-dev".wantedBy = [ "docker-registry.internal.service" ];

  environment.etc."buildkit/buildkitd.toml" = {
    text = ''
      debug = true

      [registry."registry.internal"]
        http = true
    '';
  };
}
