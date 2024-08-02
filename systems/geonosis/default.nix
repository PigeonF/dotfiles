{
  config,
  inputs,
  pkgs,
  ...
}:
{
  _file = ./default.nix;

  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480s
    inputs.self.nixosModules.default
    inputs.quadlet-nix.nixosModules.quadlet
    inputs.sops-nix.nixosModules.sops

    ./hardware.nix
    ./secrets
  ];

  system.stateVersion = "24.05";
  networking.hostName = "geonosis";

  environment.systemPackages = [
    # https://kokada.capivaras.dev/blog/quick-bits-realise-nix-symlinks/
    (pkgs.writeShellApplication {
      name = "realise-symlink";
      runtimeInputs = with pkgs; [ coreutils ];
      text = ''
        for file in "$@"; do
          if [[ -L "$file" ]]; then
            if [[ -d "$file" ]]; then
              tmpdir="''${file}.tmp"
              mkdir -p "$tmpdir"
              cp --verbose --recursive "$file"/* "$tmpdir"
              unlink "$file"
              mv "$tmpdir" "$file"
              chmod --changes --recursive +w "$file"
            else
              cp --verbose --remove-destination "$(readlink "$file")" "$file"
              chmod --changes +w "$file"
            fi
          else
            >&2 echo "Not a symlink: $file"
            exit 1
          fi
        done
      '';
    })
  ];

  pigeonf = {
    buildkit.enable = true;
    container-registry.enable = true;
    core.enable = true;
    dns.enable = true;
    docker-rootless.enable = false;
    docker.enable = true;
    guix.enable = true;
    incus.enable = true;
    nix.enable = true;
    podman.enable = true;
    pypiserver.enable = true;
    user.enable = true;
    virtualisation.containers.registries.enable = true;

    network = {
      enable = true;
      avahi.enable = true;
      envFile = config.sops.secrets."network".path;

      networks = {
        obi-lan-kenobi.enable = true;
      };
    };

    gitlab-runner = {
      enable = true;
      runners = {
        gitlab = {
          description = "gitlab.com Runner";
          envFile = config.sops.secrets."gitlab-runner-gitlab-com/environment".path;
          buildkitEnabled = true;
        };

        default = {
          description = "git.noc.rub.de Runner";
          envFile = config.sops.secrets."gitlab-runner-git-noc-rub-de/environment".path;
          buildkitEnabled = true;
        };
      };
    };
  };
}
