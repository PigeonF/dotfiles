_: {
  imports = [
    <nixpkgs/nixos/modules/profiles/hardened.nix>
    ./hardware-configuration.nix
    ./bootloader.nix
    ./vagrant.nix
    ./services
  ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22];
  networking.firewall.allowedUDPPorts = [];

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
        address = "192.168.50.127";
        prefixLength = 24;
      }
    ];
  };

  users.mutableUsers = false;
  # https://discourse.nixos.org/t/how-to-disable-root-user-account-in-configuration-nix/13235
  users.users.root = {hashedPassword = "!";};
}
