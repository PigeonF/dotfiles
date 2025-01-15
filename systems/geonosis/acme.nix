_: {
  security.acme = {
    acceptTerms = true;

    preliminarySelfsigned = false;

    defaults = {
      email = "fnoegip+letsencrypt@gmail.com";
      dnsResolver = "9.9.9.9:53";
    };
  };
}
