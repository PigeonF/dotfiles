{ pkgs, ... }:

{
  home = {
    packages = [ pkgs.gitlab-ci-local ];

    sessionVariables = {
      GCL_ARTIFACTS_TO_SOURCE = "false";
    };
  };
}
