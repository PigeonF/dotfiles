{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  git,
  typescript,
}:

let
  version = "4.48.2";
in

buildNpmPackage {
  pname = "gitlab-ci-local";
  inherit version;

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "refs/tags/${version}";
    hash = "sha256-QdbVI6aby/UQCR3G25nvmvoXNMDndgLYz/hOTmj5dnc=";
  };
  npmDepsHash = "sha256-ebrdMbSAsughHCuV86s6WA12a8hqA2yyC/rJUyViOrI=";

  patches = [
    ./dotenv-services.patch
    ./network.patch
  ];

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
