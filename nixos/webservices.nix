{
  services.dnsmasq = {
    enable = true;

    settings = {
      address = [ "/internal/127.0.0.1" ];
      local = [ "/internal/" ];

      listen-address = [
        "127.0.0.1"
        "::1"
      ];

      domain-needed = true;
    };
  };

  services.nginx = {
    enable = true;
    defaultListenAddresses = [
      "127.0.0.1"
      "[::1]"
    ];
  };
}
