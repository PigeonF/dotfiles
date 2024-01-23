{inputs, ...}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/profiles/hardened.nix"
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vagrant.nix
    ./services
  ];

  # Inserted via Vagrant
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [22];
      allowedUDPPorts = [];
    };
  };

  systemd.coredump.enable = false;

  # For VS Code server
  programs.nix-ld.enable = true;

  security.sudo.extraConfig = ''
    Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
    Defaults:root,%wheel env_keep+=NIX_PATH
    Defaults:root,%wheel env_keep+=TERMINFO_DIRS
    Defaults env_keep+=SSH_AUTH_SOCK
    Defaults lecture = never
    root   ALL=(ALL) SETENV: ALL
    %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
  '';

  networking.interfaces = {
    enp0s8.ipv4.addresses = [
      {
        address = "192.168.50.2";
        prefixLength = 24;
      }
    ];
  };

  users.mutableUsers = false;
  users.users.root = {hashedPassword = "!";};
}
