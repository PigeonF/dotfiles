{ pkgs }:

let
  inherit (pkgs) writeShellApplication;
in
{
  check-nixpkgs-fmt = (writeShellApplication {
    name = "check-nixpkgs-fmt";
    runtimeInputs = with pkgs; [ git nixpkgs-fmt findutils ];
    text = ''
      nixpkgs-fmt --check .
    '';
  });

  check-editorconfig = (writeShellApplication {
    name = "check-editorconfig";
    runtimeInputs = with pkgs; [ git eclint ];
    text = ''
      eclint .
    '';
  });
}
