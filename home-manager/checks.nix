{ inputs, ... }:
{
  _file = ./checks.nix;

  perSystem =
    { pkgs, ... }:
    {
      checks = {
        import-home-manager-modules-root = pkgs.testers.runNixOSTest {
          name = "can-import-home-manager-root-module";
          nodes = {
            machine = {
              imports = [ inputs.home-manager.nixosModules.home-manager ];
              home-manager = {
                users = {
                  inherit (inputs.self.homeModules) root;
                };
              };
            };
          };
          testScript = ''
            machine.wait_for_unit("default.target")
            machine.succeed("su -- root -c 'which rg'")
            machine.succeed("su -- root -c 'which fd'")
          '';
        };
        dotter = pkgs.testers.runNixOSTest {
          name = "dotter-module";
          nodes = {
            machine = {
              imports = [ inputs.home-manager.nixosModules.home-manager ];
              home-manager = {
                users = {
                  root = {
                    imports = [ inputs.self.homeModules.root ];
                    dotfiles = {
                      dotter = {
                        enable = true;
                        # No internet access in a VM test
                        clone = {
                          enable = false;
                        };
                        extraArgs = [
                          "--local-config"
                          ".dotter/root.toml"
                          "--cache-file"
                          "/tmp/dotter-cache.toml"
                          "--cache-directory"
                          "/tmp/dotter-cache"
                        ];
                      };
                    };
                    home = {
                      file = {
                        "git/github.com/PigeonF/dotfiles" = {
                          source = ../.;
                        };
                      };
                    };
                  };
                };
              };
            };
          };
          testScript = ''
            machine.wait_for_unit("default.target")
            machine.succeed("test -d /root/git/github.com/PigeonF/dotfiles")
            machine.succeed("grep 'catppuccin-macchiato' /root/.config/atuin/config.toml")
          '';
        };
      };
    };
}
