{
  flake.homeModules.configs = {
    rust = import ./rust.nix;
    containers = import ./containers.nix;

    tools =
      { pkgs, ... }:
      {
        home.packages = builtins.attrValues {
          inherit (pkgs)
            # committed
            dprint
            gh
            # gitlab-ci-local
            glab
            lldb
            nil
            nixfmt-rfc-style
            shfmt
            sops
            ;
        };
      };
  };
}
