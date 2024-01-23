def disksize(cfg, size)
  cfg.vm.disk :disk, primary: true, size: size
  cfg.vm.provision "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      nix-shell -p cloud-utils --run 'growpart /dev/sda 1'
      nix-shell -p e2fsprogs --run 'resize2fs /dev/sda1'
    SHELL
  end
end

def ready(cfg)
  cfg.vm.provision "shell" do |shell|
    shell.inline = <<-SHELL
      touch /tmp/provision
    SHELL
  end
end

def nixos(cfg, name)
  cfg.vm.provision "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      # We do not need them, since we use flake based dotfiles.
      rm -f /etc/nixos/*.nix
    SHELL
  end

  # Directly running the switch in a shell provision hangs indefinitely.
  cfg.trigger.after :provisioner_run, type: :hook do |trigger|
    trigger.info = "Installing OS configuration"
    trigger.run = {
      inline: "vagrant ssh #{name} -- bash -c 'test -r /tmp/provision && sudo nixos-rebuild switch --verbose --print-build-logs --show-trace --refresh --flake github:PigeonF/dotfiles?ref=main##{name} || true'"
    }
  end
end

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-secret"]

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

  config.vm.define "nixbox", primary: true do |nixbox|
    nixbox.vm.hostname = "nixbox"
    nixbox.vm.network "private_network", ip: "192.168.50.2", virtualbox__intnet: "devnet", hostname: true
    nixbox.vm.network :forwarded_port, guest: 22, host: 2200, id: "ssh"
    nixbox.vm.provider "virtualbox" do |v|
      v.name = "Nix Box"
      v.memory = 8192
      v.cpus = 6
    end
    disksize(nixbox, "256GB")
    ready(nixbox)
    nixos(nixbox, "nixbox")
  end

  config.vm.define "gitlab-runner" do |gitlab_runner|
    gitlab_runner.vm.hostname = "gitlab-runner"
    gitlab_runner.vm.network "private_network", ip: "192.168.50.3", virtualbox__intnet: "devnet", hostname: true
    gitlab_runner.vm.network :forwarded_port, guest: 22, host: 2201, id: "ssh"
    gitlab_runner.vm.provider "virtualbox" do |v|
      v.name = "GitLab Runner"
      v.memory = 4096
      v.cpus = 4
    end
    gitlab_runner.vm.provision "shell" do |shell|
      shell.privileged = true
      shell.inline = <<-SHELL
        mkdir -p /var/lib/sops-nix
        echo "#{Secret.gitlab_runner_sops}" > /var/lib/sops-nix/keys.txt
        chown root:root /var/lib/sops-nix/keys.txt
      SHELL
    end

    disksize(gitlab_runner, "128GB")
    ready(gitlab_runner)
    nixos(gitlab_runner, "gitlab-runner")

    gitlab_runner.trigger.after :provisioner_run, type: :hook do |trigger|
      trigger.warn = "You might have to register gitlab-runner manually using `vagrant ssh gitlab-runner`"
    end
  end
end
