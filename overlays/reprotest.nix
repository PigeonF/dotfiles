{
  lib,
  python3Packages,
  fetchurl,
  # Dependencies
  diffoscopeMinimal,
  disorderfs,
  libfaketime,
}:

let
  version = "0.7.27";
in

python3Packages.buildPythonApplication rec {
  pname = "reprotest";
  inherit version;
  pyproject = true;

  src = fetchurl {
    url = "mirror://debian/pool/main/r/reprotest/reprotest_${version}.tar.xz";
    hash = "sha256-sN6qdpCgyWxmfe6REcm31AcQsIKR5iIUGXwFImi4Pwo=";
  };

  build-system = [ python3Packages.setuptools ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        disorderfs
        libfaketime
        diffoscopeMinimal
      ]
    }"
  ];

  dependencies = [
    python3Packages.distro
    python3Packages.rstr
    # pkg_resources
    python3Packages.setuptools
  ];

  meta = with lib; {
    description = "Build packages and check them for reproducibility.";
    homepage = "https://salsa.debian.org/reproducible-builds/reprotest";
    license = [ licenses.gpl3Plus ];
    maintainers = [ maintainers.pigeonf ];
    mainProgram = "reprotest";
  };
}
