_:

{

  flake.nixosModules = {
    ssh =
      { lib, ... }:
      {
        services.openssh.enable = lib.mkDefault true;
        services.openssh.openFirewall = lib.mkDefault true;

        security.sudo.extraConfig = ''
          Defaults env_keep+=SSH_AUTH_SOCK
        '';
      };
  };
}
