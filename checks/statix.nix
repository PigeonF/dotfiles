{
  runCommand,
  statix,
  self,
}:
runCommand "check-statix" { } ''
  cd ${self}
  ${statix}/bin/statix check | tee $out
''
