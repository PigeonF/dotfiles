{
  config,
  lib,
  ...
}:
{
  _file = ./paperless.nix;

  services.paperless = {
    enable = true;
    settings = {
      PAPERLESS_URL = "https://paperless.rc4.xyz";
    };
  };

  services.haproxy.config = lib.mkAfter ''
    backend paperless.rc4.xyz from http-defaults
      server paperless ${config.services.paperless.address}:${toString config.services.paperless.port}
  '';
}
