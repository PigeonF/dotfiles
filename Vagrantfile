def disksize(config, size)
  config.vm.disk :disk, primary: true, size: size
  config.vm.provision "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      nix-shell -p cloud-utils --run 'growpart /dev/sda 1'
      nix-shell -p e2fsprogs --run 'resize2fs /dev/sda1'
    SHELL
  end
end

def nixos(config, name)
  config.vm.provision "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      # We do not need them, since we use flake based dotfiles.
      rm -f /etc/nixos/*.nix

      nixos-rebuild switch --flake github:PigeonF/dotfiles?ref=main##{name}
    SHELL
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "nixbox/nixos"
  config.vm.box_url = "https://app.vagrantup.com/nixbox/boxes/nixos"
  config.vm.box_version = "23.11"

  config.ssh.forward_agent = true
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Install necessary programs, and setup SSH
  config.vm.provision "shell" do |shell|
    shell.inline = <<-SHELL
      nix-env -iA nixos.git

      nix-shell -p curl --run 'curl -sL https://github.com/PigeonF.keys -o ~/.ssh/authorized_keys'

      mkdir -p ~/.ssh
      chmod 0700 ~/.ssh
      ssh-keyscan -H github.com > ~/.ssh/known_hosts
    SHELL
  end

  config.vm.define "nixbox" do |nixbox|
    nixbox.vm.hostname = "nixbox"
    nixbox.vm.provider "virtualbox" do |v|
      v.name = "Nix Box"
      v.memory = 8192
      v.cpus = 6
    end
    disksize(nixbox, "256GB")
    nixos(nixbox, "nixbox")
  end
end
