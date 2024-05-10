{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  git,
  typescript,
}:

let
  version = "4.49.0";
in

buildNpmPackage {
  pname = "gitlab-ci-local";
  inherit version;

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "refs/tags/${version}";
    hash = "sha256-hhzkC9wnPNwQwky2FegTMRIbcyCMzrZ/hoQlfZwk3sk=";
  };
  npmDepsHash = "sha256-mnnP1YvKSm/CgZYQWF8VU+cuQ0SUV5tW1dCRrGRBrmg=";

  nativeBuildInputs = [
    git
    typescript
  ];

  # `npm run build` fails because the nix store does not include git directories
  buildPhase = ''
    runHook preBuild

    tsc

    runHook postBuild
  '';

  meta = {
    homepage = "https://github.com/firecow/gitlab-ci-local";
    changelog = "https://github.com/firecow/gitlab-ci-local/releases/tag/${version}";
    description = "Tired of pushing to test your .gitlab-ci.yml?";
    mainProgram = "gitlab-ci-local";
    license = lib.licenses.mit;
  };
}
