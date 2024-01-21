{...}: {
  users.users.root = {password = "vagrant";};

  users.groups.vagrant = {
    name = "vagrant";
    members = ["vagrant"];
  };

  users.users.vagrant = {
    description = "Vagrant User";
    name = "vagrant";
    group = "vagrant";
    extraGroups = ["users" "wheel"];
    password = "vagrant";
    home = "/home/vagrant";
    createHome = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"
    ];
    isNormalUser = true;
    extraGroups = ["vboxsf"];
  };

  networking.interfaces = {
    enp0s8.ipv4.addresses = [
      {
        address = "192.168.50.3";
        prefixLength = 24;
      }
    ];
  };

  # remove the fsck that runs at startup. It will always fail to run, stopping
  # your boot until you press *.
  boot.initrd.checkJournalingFS = false;

  # Required by vagrant
  environment.systemPackages = with pkgs; [
    findutils
    gnumake
    iputils
    jq
    nettools
    netcat
    nfs-utils
    rsync
  ];
}
