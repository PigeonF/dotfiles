{
  runCommand,
  alejandra,
  self,
}:
runCommand "check-alejandra" {} ''
  ${alejandra}/bin/alejandra --check ${self} | tee $out
''
