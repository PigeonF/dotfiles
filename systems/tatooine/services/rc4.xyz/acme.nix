{ config, ... }:
{
  security.acme = {
    acceptTerms = true;

    preliminarySelfsigned = false;

    defaults = {
      email = "fnoegip+letsencrypt@gmail.com";
    };

    certs."${config.networking.domain}" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets."${config.networking.domain}/acme".path;
      extraDomainNames = [ "*.${config.networking.domain}" ];
      group = "nginx";
      reloadServices = [ "nginx.service" ];
    };
  };
}
