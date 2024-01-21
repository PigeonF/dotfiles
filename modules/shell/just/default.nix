{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      just
    ];

    sessionVariables = {
      JUST_UNSTABLE = "1";
    };
  };
}
