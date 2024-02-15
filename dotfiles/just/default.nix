{ pkgs, ... }: {
  home = {
    packages = builtins.attrValues { inherit (pkgs) just; };

    sessionVariables = { JUST_UNSTABLE = "1"; };
  };
}
