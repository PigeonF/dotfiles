Vagrant.configure("2") do |config|
  config.vm.box = "opensuse/Tumbleweed.x86_64"

  config.ssh.forward_agent = true

  config.vm.network "private_network", ip: "192.168.50.2", virtualbox__intnet: "devnet"
  config.vm.provider "virtualbox" do |v|
    v.name = "Devbox"
    v.memory = 8192
    v.cpus = 6
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.disk :disk, primary: true, size: "256GB"

  config.vm.provision "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      # Make full use of the disk space
      zypper update -y
      zypper install -y parted e2fsprogs
      parted /dev/sda resizepart 1 100%
      resize2fs /dev/sda1
    SHELL
  end

  config.vm.define "devbox" do |config|
    config.vm.hostname = "devbox"

    config.vm.provision "shell" do |shell|
      shell.privileged = true
      shell.inline = <<-SHELL
        zypper update -y
        zypper install -y curl zsh
        curl -sL https://github.com/PigeonF.keys -o ~/.ssh/authorized_keys

        useradd developer --comment "Developer" --password root
        passwd -u developer
        sudo -u developer bash -c 'mkdir -p ~/.ssh && curl -sL https://github.com/PigeonF.keys -o ~/.ssh/authorized_keys'
        echo "developer ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/developer
        chsh -s /usr/bin/zsh developer
      SHELL
    end

    config.vm.provision "shell" do |shell|
      shell.privileged = true
      shell.inline = <<-SHELL
        bash <(curl -L https://nixos.org/nix/install) --daemon
        echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf
        systemctl restart nix-daemon
        echo 'export PATH="$PATH:$HOME/.nix-profile/bin"' >> /etc/zshenv
      SHELL
    end

    config.vm.provision "shell" do |shell|
      shell.privileged = true
      shell.inline = <<-SHELL
        zypper update -y
        zypper install -y git
        sudo -u developer bash -c 'mkdir -p ~/git/github.com/PigeonF && git clone git@github.com:PigeonF/dotfiles.git ~/git/github.com/PigeonF/dotfiles'

        # Would prefer podman, but some important tools (e.g. devcontainer) do not work with podman yet...
        zypper install -y docker docker-buildx docker-compose docker-zsh-completion
        systemctl enable --now docker
        usermod -a -G docker developer

        zypper install -y nftables iptables-backend-nft
        zypper install -y -t pattern devel_basis

        curl -L "https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX10.9.sdk.tar.xz" | tar -J -x -C /opt
        curl -L "https://github.com/phracker/MacOSX-SDKs/releases/download/11.3/MacOSX11.3.sdk.tar.xz" | tar -J -x -C /opt
        echo "export SDKROOT=/opt/MacOSX11.3.sdk" > /etc/profile.d/sdkroot.sh
      SHELL
    end
  end
end
