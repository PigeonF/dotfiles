{ lib, ... }:
{
  networking = {
    firewall.enable = lib.mkDefault true;
    useDHCP = lib.mkDefault true;
  };
}
