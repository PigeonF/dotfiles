{ runCommand, nixfmt-rfc-style, self, }:
runCommand "check-nixfmt" { } ''
  ${nixfmt-rfc-style}/bin/nixfmt --check ${self} | tee $out
''
