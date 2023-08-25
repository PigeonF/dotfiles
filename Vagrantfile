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

      useradd pigeon --comment "Developer" --password root
      passwd -u pigeon
      sudo -u pigeon bash -c 'mkdir -p ~/.ssh && curl -sL https://github.com/PigeonF.keys -o ~/.ssh/authorized_keys'
      echo "pigeon ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/pigeon
    SHELL
    shell.reboot = true
  end

  config.vm.define "devbox" do |config|
    config.vm.provision "shell" do |shell|
      shell.privileged = true
      shell.inline = <<-SHELL
        zypper install -y git zsh
        sudo -u pigeon bash -c 'mkdir -p ~/git/github.com/PigeonF && git clone git@github.com:PigeonF/dotfiles.git ~/git/github.com/PigeonF/dotfiles'
        sudo chsh -s /usr/bin/zsh pigeon

        bash <(curl -L https://nixos.org/nix/install) --daemon
        echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
        systemctl restart nix-daemon
      SHELL
    end
  end
end
