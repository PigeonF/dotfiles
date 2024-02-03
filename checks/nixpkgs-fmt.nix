{ runCommand
, nixpkgs-fmt
, self
}:
runCommand "check-nixpkgs-fmt" { } ''
  ${nixpkgs-fmt}/bin/nixpkgs-fmt --check ${self} | tee $out
''
