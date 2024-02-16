{ ... }:
{
  imports = [
    ./openssh.nix
    ./gitlab-runner
  ];

  services = {
    dbus.enable = true;
    timesyncd.enable = true;
    logrotate.checkConfig = false;
  };
}
