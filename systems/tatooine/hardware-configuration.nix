{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "virtio_scsi"
        "sr_mod"
      ];
      kernelModules = [ "virtio_gpu" ];
    };
    kernelParams = [ "console=tty" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
