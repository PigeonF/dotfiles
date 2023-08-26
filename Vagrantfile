Vagrant.configure("2") do |config|
  config.vm.box = "opensuse/Tumbleweed.x86_64"

  config.ssh.forward_agent = true

  config.vm.network "private_network", ip: "192.168.50.2", virtualbox__intnet: "devnet"
  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.cpus = 6
  end

  config.vm.provision "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      zypper update -y
      zypper install -y curl
      curl -sL https://github.com/PigeonF.keys -o ~/.ssh/authorized_keys

      useradd developer --comment "Developer" --password root
      passwd -u developer
      sudo -u developer bash -c 'mkdir -p ~/.ssh && curl -sL https://github.com/PigeonF.keys -o ~/.ssh/authorized_keys'
      echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/developer
    SHELL
    shell.reboot = true
  end

  config.vm.define "devbox" do |config|
    config.vm.hostname = "devbox"

    config.vm.provision "shell" do |shell|
      shell.privileged = true
      shell.inline = <<-SHELL
        zypper install -y git zsh
        sudo -u developer bash -c 'mkdir -p ~/git/github.com/PigeonF && git clone git@github.com:PigeonF/dotfiles.git ~/git/github.com/PigeonF/dotfiles'
        sudo chsh -s /usr/bin/zsh developer

        bash <(curl -L https://nixos.org/nix/install) --daemon
        echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
        systemctl restart nix-daemon

        # Would prefer podman, but some important tools (e.g. devcontainer) do not work with podman yet...
        zypper install -y docker docker-buildx docker-compose docker-zsh-completion
        systemctl enable --now docker
        usermod -a -G docker developer
      SHELL
    end
  end
end
