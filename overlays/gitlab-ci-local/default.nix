{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage {
  pname = "gitlab-ci-local";
  version = "4.52.1";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "2493c9dfdae16308994ff38ccaf6dfae17012520";
    hash = "sha256-fH1qXekTy+dg5Nr4Z1NlKyXOEHfS+3o9WVAawmYtvHU=";
  };

  npmDepsHash = "sha256-8Fxkd3JPyspcZeENpvvuguPNXbnWL1WrcYL9c77+Gok=";

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"
  '';

  passthru.updateScript = nix-update-script { };

  patches = [
    ./umask.patch
    ./1301.patch
  ];

  meta = with lib; {
    description = "Run gitlab pipelines locally as shell executor or docker executor";
    mainProgram = "gitlab-ci-local";
    longDescription = ''
      Tired of pushing to test your .gitlab-ci.yml?
      Run gitlab pipelines locally as shell executor or docker executor.
      Get rid of all those dev specific shell scripts and make files.
    '';
    homepage = "https://github.com/firecow/gitlab-ci-local";
    license = licenses.mit;
    maintainers = with maintainers; [ pineapplehunter ];
    platforms = platforms.all;
  };
}
