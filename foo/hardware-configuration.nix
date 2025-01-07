# SPDX-FileCopyrightText: 2025 Jonas Fierlings <fnoegip@gmail.com>
#
# SPDX-License-Identifier: 0BSD
{
  lib,
  modulesPath,
  ...
}:

{
  _file = ./hardware-configuration.nix;

  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
