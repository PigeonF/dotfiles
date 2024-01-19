{ config, pkgs, ... }:
{
  networking.interfaces = {
    enp0s8.ipv4.addresses = [{
      address = "192.168.50.3";
      prefixLength = 24;
    }];
  };
}
