{
  runCommand,
  deadnix,
  self,
}:
runCommand "check-deadnix" {} ''
  ${deadnix}/bin/deadnix -f ${self} | tee $out
''
