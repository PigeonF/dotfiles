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
  version = "c5524204d56101dbab8ed8db3c70f5dd72891dab"; # "4.46.1";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "${version}";
    hash = "sha256-gjVwbXlgF96nNxSoBn/kBUOdNZwQxLQwWXDMotpqfnI=";
  };

  patches = [ ./dotenv-services.patch ];

  npmDepsHash = "sha256-55riOAlUeJjv/BRCVb1K+GS3haVRYXGUc7KpaSRboJg=";

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
