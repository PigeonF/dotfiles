Vagrant.configure("2") do |config|
  config.vm.box = "nixbox/nixos"
  config.vm.box_url = "https://app.vagrantup.com/nixbox/boxes/nixos"
  config.vm.box_version = "23.11"

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.name = "Nix Box"
    v.memory = 8192
    v.cpus = 6
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.disk :disk, primary: true, size: "256GB"
  config.vm.provision "shell" do |shell|
    shell.privileged = true
    shell.inline = <<-SHELL
      nix-shell -p cloud-utils --run 'growpart /dev/sda 1'
      nix-shell -p e2fsprogs --run 'resize2fs /dev/sda1'

      nix-env -iA nixos.git
    SHELL
  end

  config.vm.define "nixbox" do |config|
    config.vm.hostname = "nixbox"


    config.vm.provision "shell" do |shell|
      shell.privileged = true

      shell.inline = <<-SHELL
        # We do not need them, since we use flake based dotfiles.
        rm -f /etc/nixos/*.nix

        mkdir -p ~/.ssh
        ssh-keyscan github.com > ~/.ssh/known_hosts
      SHELL
    end

    # https://github.com/hashicorp/vagrant/issues/12062
    # For some reason doing the `vagrant ssh -- ...` dance ourselves using
    # trigger.run does not work either, even though `ssh-add -l` gives the
    # correct keys. Thus, only print a warning for now.
    config.trigger.after :provisioner_run, type: :hook do |trigger|
      trigger.warn = "Run `vagrant ssh -- 'sudo nixos-rebuild switch --flake git+ssh://git@github.com/PigeonF/dotfiles?ref=main'` to finish provisioning"
    end
  end
end
