{
  config,
  ...
}:
{
  _file = ./haproxy.nix;

  security.acme = {
    certs = {
      "rc4.xyz" = {
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets."acme/rc4.xyz".path;
        extraDomainNames = [ "*.rc4.xyz" ];
        group = "haproxy";
        reloadServices = [ "haproxy.service" ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.haproxy = {
    enable = true;
    config = ''
      global
        # Process management and security
        # fd-hard-limit 32768
        log "/dev/log" len 65535 format "rfc3164" daemon info err
        # Performance tuning
        maxconn 16384

      defaults http-defaults
        mode http
        option httplog
        option forwardfor
        option dontlognull
        log global
        timeout client 30s
        timeout server 30s
        timeout connect 5s
        default_backend no-match

      crt-store http
        crt-base /var/lib/acme
        key-base /var/lib/acme
        load crt "rc4.xyz/cert.pem" key "rc4.xyz/key.pem" alias "rc4.xyz"

      backend no-match from http-defaults
        http-request deny deny_status 403

      # http to https redirect
      frontend http-redirect from http-defaults
        bind *:80,:::80 v6only
        http-request redirect scheme https code 301

      frontend https-redirect from http-defaults
        bind *:443,:::443 v6only
        mode tcp
        option tcplog
        tcp-request inspect-delay 5s
        tcp-request content accept if { req_ssl_hello_type 1 }
        acl local src 127.0.0.0/8
        acl localv6 src ::1/128
        acl internal src 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
        acl internalv6 src fc00::/7 fe80::/10
        use_backend local if local OR localv6
        use_backend internal if internal OR internalv6

      frontend local from http-defaults
        bind abns@local accept-proxy ssl crt "@http/rc4.xyz"
        use_backend %[req.hdr(host),lower]

      backend local from http-defaults
        mode tcp
        server loopback-for-tls abns@local send-proxy-v2

      frontend internal from http-defaults
        bind abns@internal accept-proxy ssl crt "@http/rc4.xyz"
        use_backend %[req.hdr(host),lower]

      backend internal from http-defaults
        mode tcp
        server loopback-for-tls abns@internal send-proxy-v2
    '';
  };
}
