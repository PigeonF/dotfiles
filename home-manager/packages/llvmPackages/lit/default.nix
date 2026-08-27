{
  stdenv,
  llvm_meta,
  version,
  src ? null,
  monorepoSrc ? null,
  runCommand,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  passthru.monorepoSrc = monorepoSrc;
  pname = "lit";
  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "lit-src-${version}" { inherit (monorepoSrc) passthru; } (''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/llvm/utils/lit "$out"
      '')
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/lit";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/lit $out/bin

    cp -r lit.py lit $out/share/lit

    ln -s $out/share/lit/lit.py $out/bin/lit

    runHook postInstall
  '';

  outputs = [ "out" ];

  meta = llvm_meta // {
    description = "LLVM Integrated Tester";
    homepage = "https://llvm.org/docs/CommandGuide/lit.html";
    mainProgram = "lit";
  };
})
