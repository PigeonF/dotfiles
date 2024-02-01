_: {
  imports = [
    ./openssh.nix
    ./docker-registry.nix
  ];

  services.dbus.enable = true;
  services.timesyncd.enable = true;
}
