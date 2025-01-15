{
  lib,
  ...
}:
{
  _file = ./incus.nix;

  # services.haproxy.config = lib.mkAfter ''
  #   backend foo.rc4.xyz from http-defaults
  #     server foo foo.incus:80
  # '';
}
