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

    oci-containers.containers."registry-cache.internal" = {
      image = "docker.io/registry";
      ports = [
        "127.0.0.1:5050:80"
        "[::1]:5050:80"
      ];
      environment = {
        REGISTRY_HTTP_ADDR = "0.0.0.0:80";
        REGISTRY_PROXY_REMOTEURL = "https://registry-1.docker.io";
      };
      extraOptions = [ "--network=dev" ];
    };

    docker.daemon.settings."insecure-registries" = [
      "registry.internal"
      "registry-cache.internal"
    ];
  };
  systemd.services."docker-registry.internal".wantedBy = [ "docker-network-dev.service" ];
  systemd.services."docker-registry-cache.internal".wantedBy = [ "docker-network-dev.service" ];

  services.nginx.virtualHosts."registry.internal".locations."/" = {
    proxyPass = "http://127.0.0.1:5000/";
    extraConfig = ''
      client_max_body_size 0;
    '';
  };

  services.nginx.virtualHosts."registry-cache.internal".locations."/" = {
    proxyPass = "http://127.0.0.1:5050/";
    extraConfig = ''
      client_max_body_size 0;
    '';
  };

  # docker buildx create --use --driver docker-container --driver-opt "network=dev" --config /etc/buildkit/buildkitd.toml
  environment.etc."buildkit/buildkitd.toml" = {
    text = ''
      insecure-entitlements = [ "network.host", "security.insecure" ]

      [registry."registry.internal"]
        http = true

      [registry."registry-cache.internal"]
        http = true
    '';
  };
}
