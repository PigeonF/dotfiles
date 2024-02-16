{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  git,
  typescript,
}:
buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "4.46.1";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "${version}";
    hash = "sha256-0NUmsbuzs004w9ETj4e4nO+sDvYHQh9SwJoRc3+r+j8=";
  };

  patches = [ ./dotenv-services.patch ];

  npmDepsHash = "sha256-zCBNUKmLluVCDoPHuKy9KMKCGL8FqopFhKq7QCAUe4U=";

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
