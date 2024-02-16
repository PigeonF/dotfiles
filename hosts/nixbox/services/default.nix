_: {
  imports = [
    ./openssh.nix
    ./docker-registry
  ];

  services.dbus.enable = true;
  services.timesyncd.enable = true;
}
