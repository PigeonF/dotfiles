{ lib
, buildNpmPackage
, fetchFromGitHub
, git
, typescript
}:
buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.46.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "${version}";
    hash = "sha256-CW2IkXGUohFtYZB3eNi0cl8rUWW/gIyUQPYxaextAfk=";
  };

  npmDepsHash = "sha256-4nfu8Au/Uk2oTSKbuv8QlvfLs0EgDlEgtBl/Nxv07oY=";

  nativeBuildInputs = [
    git
    typescript
  ];

  npmFlags = builtins.toString [ "--ignore-scripts" ];

  buildPhase = ''
    runHook preBuild

    tsc

    runHook postBuild
  '';

  meta = {
    description = "Tired of pushing to test your .gitlab-ci.yml?";
    homepage = "https://github.com/firecow/gitlab-ci-local";
    license = lib.licenses.mit;
  };
}
