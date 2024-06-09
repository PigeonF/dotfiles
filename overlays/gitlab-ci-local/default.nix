{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "gitlab-ci-local";
  version = "master";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "ba3509a42b5e0155913fb09d0885c93284df1f39";
    hash = "sha256-q77+/Hy4YDC/RG9Evx0yjlBOz/VIfmFGrKgrANGI7jQ=";
  };

  npmDepsHash = "sha256-Z9ikvEdPeg1qHbwqLVqQ1YZEl4eZc68QJ4N2ZF/OroQ=";

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"
  '';

  passthru.updateScript = nix-update-script { };

  patches = [
    ./pr-1261.patch
    ./umask.patch
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
