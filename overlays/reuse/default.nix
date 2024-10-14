{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  attrs,
  binaryornot,
  boolean-py,
  debian,
  freezegun,
  jinja2,
  license-expression,
  tomlkit,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "reuse";
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fsfe";
    repo = "reuse-tool";
    rev = "fb847af27bdfb4197b15b005696ccef81b55de41"; # "refs/tags/v${version}";
    hash = "sha256-DF9KTBvOZ6pkHFhRXyRury2n6/DhOJgMkmflZ31uRMM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    attrs
    binaryornot
    boolean-py
    debian
    jinja2
    license-expression
    tomlkit
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  disabledTestPaths = [
    # pytest wants to execute the actual source files for some reason, which fails with ImportPathMismatchError()
    "src/reuse"
  ];

  pythonImportsCheck = [ "reuse" ];

  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
    homepage = "https://github.com/fsfe/reuse-tool";
    changelog = "https://github.com/fsfe/reuse-tool/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20
      cc-by-sa-40
      cc0
      gpl3Plus
    ];
    maintainers = with maintainers; [
      FlorianFranzen
      Luflosi
    ];
    mainProgram = "reuse";
  };
}
