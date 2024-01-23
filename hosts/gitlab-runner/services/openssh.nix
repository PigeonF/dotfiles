_: {
  # For vagrant key
  services.openssh = {
    extraConfig = ''
      PubkeyAcceptedKeyTypes +ssh-rsa
    '';
    openFirewall = true;
  };
}
