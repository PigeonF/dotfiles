{ pkgs, ... }: {
  users.groups.vagrant = {
    name = "vagrant";
    members = [ "vagrant" ];
  };

  users.users.vagrant = {
    description = "Vagrant User";
    name = "vagrant";
    group = "vagrant";
    extraGroups = [ "users" "wheel" "vboxsf" ];
    hashedPassword = "!";
    home = "/home/vagrant";
    createHome = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSGbm3QEVQFhYqJM29rQ6WibpQr613KgxoYTr/QvztV"
    ];
    isNormalUser = true;
  };

  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *.
  boot.initrd.checkJournalingFS = false;

  # Required by vagrant
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      findutils
      gnumake
      iputils
      jq
      nettools
      netcat
      nfs-utils
      rsync
      ;
  };
}
