_: {
  # For vagrant key
  services.openssh = {
    enable = true;
    extraConfig = ''
      PubkeyAcceptedKeyTypes +ssh-rsa
    '';
    openFirewall = true;
  };
}
