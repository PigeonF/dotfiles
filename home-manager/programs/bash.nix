{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.dotfiles.programs.bash;
in
{
  _file = ./bash.nix;

  options.dotfiles.programs = {
    bash = {
      enable = mkEnableOption "set up bash";
      extraPackages = mkOption {
        default = [
          pkgs.moreutils
        ];
        example = lib.literalExpression ''
          [
            pkgs.coreutils
          ]
        '';
        type = types.listOf types.package;
        description = ''
          Extra packages that should be installed to the home profile.
        '';
      };
    };
  };

  config = lib.mkMerge [
    {
      programs.bash = {
        inherit (cfg) enable;
        historyFile = "${config.xdg.dataHome}/bash/bash_history";
      };
    }
    (lib.mkIf cfg.enable {
      home = {
        packages = cfg.extraPackages;
      };
    })
    (lib.mkIf (cfg.enable && config.home.preferXdgDirectories) {
      home = {
        activation = {
          xdgBashFiles =
            let
              writeProfile =
                name: file:
                pkgs.writeTextFile {
                  inherit name;
                  checkPhase = ''
                    ${pkgs.stdenv.shellDryRun} "$target"
                  '';
                  text = ''
                    if [ -r "$HOME"/${lib.escapeShellArg file.target} ]; then
                      . "$HOME"/${lib.escapeShellArg file.target}
                    fi
                  '';
                };
              bashProfile = writeProfile "bash_profile" config.home.file.".bash_profile";
              profile = writeProfile "profile" config.home.file.".profile";
              bashrc = writeProfile "bashrc" config.home.file.".bashrc";
            in
            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              if [ ! -s "$HOME/.bash_profile" ]; then
                run cp $VERBOSE_ARG --no-preserve=all -f -L ${bashProfile} "$HOME/.bash_profile"
              fi

              if [ ! -s "$HOME/.profile" ]; then
                run cp $VERBOSE_ARG --no-preserve=all -f -L ${profile} "$HOME/.profile"
              fi

              if [ ! -s "$HOME/.bashrc" ]; then
                run cp $VERBOSE_ARG --no-preserve=all -f -L ${bashrc} "$HOME/.bashrc"
              fi
            '';
        };
        file = {
          ".bash_profile" = {
            target = ".config/bash/bash_profile";
          };
          ".profile" = {
            target = ".config/bash/profile";
          };
          ".bashrc" = {
            target = ".config/bash/bashrc";
          };
        };
        sessionVariables = {
          BASH_COMPLETION_USER_FILE = lib.mkIf config.programs.bash.enableCompletion "${config.xdg.configHome}/bash-completion/bash_completion";
        };
      };
    })
  ];
}
