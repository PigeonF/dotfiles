{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage {
  pname = "gitlab-ci-local";
  version = "4.52.2";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "5afc8a11b3d71069fbb0a0660aa301382847bee4";
    hash = "sha256-pANdLoClkskKnCe9A6pulL6mtWr0W7pNeHondd3viW4=";
  };

  npmDepsHash = "sha256-YN4pSoTqNX6yLKkcW6ieB+5LNZQV/TzkPtWtv2mLIHo=";

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"
  '';

  passthru.updateScript = nix-update-script { };

  patches = [
    ./umask.patch
    ./1320.patch
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
