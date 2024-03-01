{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  git,
  typescript,
}:
buildNpmPackage rec {
  pname = "gitlab-ci-local";
  # Includes components implementation
  version = "0e3602b530bbad48c96006f589022095ae6b58a6"; # "4.46.1";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "${version}";
    hash = "sha256-qtXCYv3M2HxG8LzCEw4mUOWgEmdivo4O8mhKBSaJN80=";
  };

  patches = [
    ./dotenv-services.patch
    ./include-multiple.patch
  ];

  npmDepsHash = "sha256-49pGubOt5XZq4cYXAtmthkDjiH/mQz707PCSrO7SKnU=";

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
