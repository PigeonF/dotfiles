{ config, ... }:
{
  security.acme = {
    acceptTerms = true;

    preliminarySelfsigned = false;

    defaults = {
      email = "fnoegip+letsencrypt@gmail.com";
    };

    certs."rc4.xyz" = {
      dnsProvider = "cloudflare";
      credentialsFile = config.sops.secrets."rc4.xyz/acme".path;
      extraDomainNames = [ "*.rc4.xyz" ];
      group = "nginx";
      reloadServices = [ "nginx.service" ];
    };
  };
}
