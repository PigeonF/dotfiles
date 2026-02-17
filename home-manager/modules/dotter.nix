{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.dotfiles.dotter;
in
{
  _file = ./dotter.nix;

  options.dotfiles = {
    dotter = {
      enable = mkEnableOption "install a dotfiles repository with dotter";
      package = lib.mkPackageOption pkgs "dotter" { };
      clone = {
        enable = mkEnableOption "clone the dotfiles repository if it does not exist";
        repository = mkOption {
          type = types.str;
          default = "https://github.com/PigeonF/dotfiles.git";
          description = ''
            The dotfiles repository to clone.
          '';
        };
      };
      location = mkOption {
        type = types.either types.str types.path;
        default = "${config.home.homeDirectory}/git/github.com/PigeonF/dotfiles";
        description = ''
          Location of the dotfiles repository to install.
        '';
      };
      extraArgs = mkOption {
        type = types.listOf (types.either types.str types.path);
        default = [ ];
        description = ''
          Arguments to pass to `dotter`.
        '';
        example = [
          "--local-config"
          (pkgs.writeText "local.toml" ''
            packages = ["foo"]
          '')
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      activation = {
        dotterCloneRepository = lib.mkIf cfg.clone.enable (
          lib.hm.dag.entryBetween [ "dotter" ] [ "writeBoundary" ] ''
            if [ ! -d ${lib.escapeShellArg cfg.location} ]; then
              run mkdir -p "$(dirname "${lib.escapeShellArg cfg.location}")"
              run ${lib.getExe pkgs.gitMinimal} clone ${lib.escapeShellArg cfg.clone.repository} ${lib.escapeShellArg cfg.location}
            else
              verboseEcho 'Refusing to clone' ${lib.escapeShellArg cfg.clone.repository} 'because destination' ${lib.escapeShellArg cfg.location} 'exists already.'
              run git --git-dir=${lib.escapeShellArg cfg.location} pull origin main || true
            fi
          ''
        );
        dotter = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -d ${lib.escapeShellArg cfg.location} ]; then
            echo 1>&2 'Unable to run dotter to install dotfiles in' ${lib.escapeShellArg cfg.location} ': directory does not exist'
            exit 1
          fi
          (cd ${lib.escapeShellArg cfg.location}; ${lib.getExe cfg.package} ''${VERBOSE_ARG} ''${DRY_RUN+--dry-run} --noconfirm ${lib.escapeShellArgs cfg.extraArgs})
        '';
      };
      packages = [ cfg.package ];
    };
  };
}
