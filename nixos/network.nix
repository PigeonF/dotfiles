_:

{
  flake.nixosModules = {
    network =
      { lib, ... }:
      {
        networking = {
          firewall.enable = lib.mkDefault true;
          useDHCP = lib.mkDefault true;
        };
      };
  };
}
