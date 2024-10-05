{
  imports = [
    ./openssh.nix
    ./rc4.xyz/acme.nix
    ./rc4.xyz/nginx.nix
  ];

  services.udev.enable = false;
  services.lvm.enable = false;
}
