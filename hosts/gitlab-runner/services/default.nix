{ ... }:
{
  imports = [
    ./openssh.nix
    ./gitlab-runner
  ];

  services.dbus.enable = true;
  services.timesyncd.enable = true;
}
