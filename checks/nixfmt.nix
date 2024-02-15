{ runCommand, nixfmt, self, }:
runCommand "check-nixfmt" { } ''
  ${nixfmt}/bin/nixfmt --check ${self} | tee $out
''
