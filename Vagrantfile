Vagrant.configure("2") do |config|
  config.vm.box = "nixbox/nixos"
  config.vm.box_url = "https://app.vagrantup.com/nixbox/boxes/nixos"
  config.vm.box_version = "23.11"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  pubkey = File.expand_path("../.vagrant/pigeonf.pub", __FILE__)
  unless File.exists?(pubkey)
    require 'net/http'

    File.write(pubkey, Net::HTTP.get(URI.parse("https://github.com/PigeonF.keys")))
  end

  # The insecure key will be overwritten by the nixOS configuration
  config.ssh.insert_key = false
  config.ssh.private_key_path = [
    # We use a public key so that ssh-agent is used.
    pubkey,
    File.expand_path('~/.vagrant.d/insecure_private_keys/vagrant.key.ed25519'),
    File.expand_path('~/.vagrant.d/insecure_private_keys/vagrant.key.rsa'),
  ]
  config.ssh.forward_agent = true

  config.vm.define "mustafar" do |mustafar|
    mustafar.vm.hostname = "mustafar"
    mustafar.vm.network :forwarded_port, guest: 22, host: 2201, id: "ssh"

    virtualbox(mustafar, name: "Mustafar", memory: 8192, cpus: 4)
    disksize(mustafar, "128GB")
    sops(mustafar, ENV['MUSTAFAR_HOST_KEY'])
    nixos(mustafar, "mustafar")
  end
end

def virtualbox(cfg, name:, memory:, cpus:, kvm: false)
  cfg.vm.provider "VirtualBox settings" do |v|
    v.name = name
    v.memory = memory
    v.cpus = cpus

    if kvm
      v.customize ["modifyvm", :id, "--paravirtprovider", "kvm"]
    end
  end
end

def disksize(cfg, size)
  cfg.vm.disk :disk, primary: true, size: size

  cfg.vm.provision "Make full use of resized disk", type: "shell" do |shell|
    shell.inline = <<-SHELL
      nix-shell -p cloud-utils --run 'growpart /dev/disk/by-diskseq/1 1'
      nix-shell -p e2fsprogs --run 'resize2fs /dev/disk/by-diskseq/1-part1'
    SHELL
  end
end

def sops(cfg, host_key)
  cfg.vm.provision "Set up Host Key for use with SOPS", type: "shell" do |shell|
    shell.env = {
      "HOST_KEY" => (host_key or "")
    }

    shell.inline = <<-SHELL
      set -o errexit
      set -o nounset
      set -o pipefail

      HOST_KEY_ED25519=$(nix-shell -p dos2unix --run 'echo "$HOST_KEY" | dos2unix')

      if [[ -z "$HOST_KEY_ED25519" ]]; then
          # Required in order to decrypt sops secrets
          echo "Provisioning requires a host key. Run with 'op run --env-file vagrant.env -- vagrant up'"
          exit 1
      fi

      echo "Overwriting ed25519 host key..."
      echo "$HOST_KEY_ED25519" > /etc/ssh/ssh_host_ed25519_key
      ssh-keygen -y -f /etc/ssh/ssh_host_ed25519_key | tee /etc/ssh/ssh_host_ed25519_key.pub
    SHELL
  end
end

def nixos(cfg, name)
  cfg.vm.provision "nixos-rebuild for #{name}", type: "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      # We do not need them, since we use flake based dotfiles.
      rm -f /etc/nixos/*.nix

      if ! type git &> /dev/null; then
        nix-env -iA nixos.git
      fi

      nixos-rebuild build --verbose --print-build-logs --show-trace --refresh --flake github:PigeonF/dotfiles?ref=main##{name} --accept-flake-config
      nixos-rebuild switch --flake 'github:PigeonF/dotfiles?ref=main##{name}' --no-write-lock-file
    SHELL
  end
end
