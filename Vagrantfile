def virtualbox(cfg, name:, memory:, cpus:, kvm: true)
  cfg.vm.provider "virtualbox" do |v|
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
    shell.privileged = true
    shell.inline = <<-SHELL
      nix-shell -p cloud-utils --run 'growpart /dev/sda 1'
      nix-shell -p e2fsprogs --run 'resize2fs /dev/sda1'
    SHELL
  end
end

def sops(cfg, secret)
  cfg.vm.provision "Setting up SOPS secrets", type: "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      mkdir -p /var/lib/sops-nix
      echo "#{secret}" > /var/lib/sops-nix/keys.txt

      chown -R root:root /var/lib/sops-nix/
      chmod 0600 /var/lib/sops-nix/keys.txt
    SHELL
  end
end

def nixos(cfg, name)
  cfg.vm.provision "nixos-rebuild for #{name}", type: "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      # We do not need them, since we use flake based dotfiles.
      rm -f /etc/nixos/*.nix
      # Provisioning hack is needed because running nixos-rebuild switch in here
      # leads to vagrant getting stuck.
      #
      # We build here, but switch in a trigger
      nixos-rebuild build --verbose --print-build-logs --show-trace --refresh --flake github:PigeonF/dotfiles?ref=main##{name}
      mkdir -p /tmp
      echo "exec sudo nixos-rebuild switch --flake 'github:PigeonF/dotfiles?ref=main##{name}' --no-write-lock-file" > /tmp/nixos-rebuild-switch.bash
    SHELL
  end

  # Directly running the switch in a shell provision hangs indefinitely.
  cfg.trigger.after :provisioner_run, type: :hook do |trigger|
    trigger.info = "Checking if nixos-rebuild needs switch"
    trigger.run = {
      inline: "vagrant ssh #{name} -- bash /tmp/nixos-rebuild-switch.bash"
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

  config.vm.provision "Setup SSH", type: "shell" do |shell|
    shell.inline = <<-SHELL
      # We need to create this file now, because the trigger will run every time
      touch /tmp/nixos-rebuild-switch.bash

      if ! type git &> /dev/null; then
        nix-env -iA nixos.git
      fi

      mkdir -p ~/.ssh
      chmod 0700 ~/.ssh
      if [[ ! -r ~/.ssh/authorized_keys ]]; then
        nix-shell -p curl --run 'curl -sL https://github.com/PigeonF.keys -o ~/.ssh/authorized_keys'
      fi
      if [[ ! -r ~/.ssh/known_hosts ]]; then
        ssh-keyscan -H github.com > ~/.ssh/known_hosts
      fi
    SHELL
  end

  config.vm.define "nixbox", primary: true do |nixbox|
    nixbox.vm.hostname = "nixbox"
    nixbox.vm.network :forwarded_port, guest: 22, host: 2200, id: "ssh"

    virtualbox(nixbox, name: "Nix Box", memory: 8192, cpus: 6)
    disksize(nixbox, "256GB")
    sops(nixbox, Secret.nixbox_sops)
    nixos(nixbox, "nixbox")
  end

  config.vm.define "gitlab-runner" do |gitlab_runner|
    gitlab_runner.vm.hostname = "gitlab-runner"
    gitlab_runner.vm.network :forwarded_port, guest: 22, host: 2201, id: "ssh"

    virtualbox(gitlab_runner, name: "GitLab Runner", memory: 8192, cpus: 4)
    sops(gitlab_runner, Secret.gitlab_runner_sops)
    disksize(gitlab_runner, "128GB")
    nixos(gitlab_runner, "gitlab-runner")
  end
end
