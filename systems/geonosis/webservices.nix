{
  services.dnsmasq = {
    enable = true;

    settings = {
      address = [ "/internal/127.0.0.1" ];
      bind-interfaces = true;
      domain-needed = true;
      interface = [ "wlp61s0" ];
      listen-address = [
        "127.0.0.1"
        "::1"
      ];
      local = [
        "/internal/"
        "/fritz.box/"
      ];
    };
  };

  systemd.services.dnsmasq = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
  };

  services.nginx = {
    enable = true;
    defaultListenAddresses = [
      "127.0.0.1"
      "[::1]"
    ];
  };
}
