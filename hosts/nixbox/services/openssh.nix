_: {
  services.openssh.enable = true;
  # For vagrant key
  services.openssh.extraConfig = ''
    PubkeyAcceptedKeyTypes +ssh-rsa
  '';
}
