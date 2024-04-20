{ config, pkgs, ... }:

{
  home = {
    packages = [ pkgs.go ];

    sessionVariables = {
      GOPATH = "${config.xdg.dataHome}/go";
    };

    sessionPath = [ "$GOPATH/bin" ];
  };
}
