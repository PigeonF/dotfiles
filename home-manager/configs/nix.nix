{ pkgs, ... }:

{
  home = {
    packages = builtins.attrValues { inherit (pkgs) nil nixfmt-rfc-style sops; };
  };
}
