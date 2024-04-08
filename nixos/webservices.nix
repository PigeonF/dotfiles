{
  flake.nixosModules.webservices =
    {
      inputs,
      lib,
      config,
      ...
    }:
    let
      inherit (inputs.nixpkgs-networking.lib) ipv4;
      listenAddress =
        if config.virtualisation.docker.enable then
          if config.virtualisation.docker.daemon.settings ? bip then
            ipv4.prettyIp (ipv4.cidrToFirstUsableIp config.virtualisation.docker.daemon.settings.bip)
          else
            "172.17.0.1"
        else
          "127.0.0.1";
    in
    {
      # Enable dnsmasq, which forwards and listens on .localhost to (127.0.0.1 or docker0)
      # Enable caddy

      services.dnsmasq = {
        enable = true;

        settings = {
          address = [ "/internal/${listenAddress}" ];
          local = [ "/internal/" ];

          listen-address = lib.lists.unique [
            "${listenAddress}"
            "127.0.0.1"
            "::1"
          ];

          domain-needed = true;
        };
      };

      virtualisation.docker.daemon.settings.dns = [
        listenAddress
        "8.8.8.8"
        "8.8.4.4"
      ];

      services.caddy.enable = true;

      services.caddy.virtualHosts."hello.internal".extraConfig = ''
        tls internal
        respond "Hello, world!"
      '';
    };
}
