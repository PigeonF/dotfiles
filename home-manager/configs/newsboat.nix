{ pkgs, lib, ... }:

{
  programs.newsboat = {
    enable = true;
    browser = "${lib.getExe pkgs.lynx}";

    extraConfig = ''
      color listnormal         color15 default
      color listnormal_unread  color2  default
      color listfocus_unread   color2  color0
      color listfocus          default color0
      color background         default default
      color article            default default
      color end-of-text-marker color8  default
      color info               color4  color8
      color hint-separator     default color8
      color hint-description   default color8
      color title              color14 color8

      highlight article "^(Feed|Title|Author|Link|Date): .+" color4 default bold
      highlight article "^(Feed|Title|Author|Link|Date):" color14 default bold

      highlight article "\\((link|image|video)\\)" color8 default
      highlight article "https?://[^ ]+" color4 default
      highlight article "\[[0-9]+\]" color6 default bold
    '';

    urls = [
      {
        url = "https://github.com/crate-ci/committed/releases.atom";
        tags = [
          "github"
          "release"
        ];
        title = "`github:crates-ci/committed` releases";
      }
    ];
  };
}
