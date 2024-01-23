{pkgs, ...}: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = true;
  virtualisation.docker.enable = true;

  # Due to
  # - https://github.com/NixOS/nixpkgs/issues/158284
  # - https://github.com/NixOS/nixpkgs/issues/282238
  # we register the runners manually.
  #
  # This means the config is not really declarative, but thats how it is.
  services.gitlab-runner = {
    enable = true;
    configFile = pkgs.writeText "config.template.toml" ''

    '';
  };

  # Make sure folder gets created or gitlab-runner service will fail
  systemd.tmpfiles.rules = [
    "d /var/lib/gitlab-runner/.gitlab-runner 1777 root root"
  ];

  services.cron = {
    enable = true;
    systemCronJobs = [
      "@daily root ${pkgs.docker-gc}/bin/docker-gc"
    ];
  };
}
