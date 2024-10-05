{
  _file = ./default.nix;

  sops.secrets = {
    "rc4.xyz/acme" = {
      sopsFile = ./rc4.xyz/acme.env;
      format = "dotenv";
      restartUnits = [ "acme-rc4.xyz.service" ];
    };
  };
}
