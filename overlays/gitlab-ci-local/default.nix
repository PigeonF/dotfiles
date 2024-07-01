{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildNpmPackage {
  pname = "gitlab-ci-local";
  version = "master";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = "4.52.0";
    hash = "sha256-rdG5mcNgRUdFS6zdRNLoawIvXLzG/ZW6tOF4EkPUymg=";
  };

  npmDepsHash = "sha256-erDRpN9EtGS1K6SRsujeqmUflRNGUjHOeUvYJD3Nkmg=";

  postPatch = ''
    # remove cleanup which runs git commands
    substituteInPlace package.json \
      --replace-fail "npm run cleanup" "true"
  '';

  passthru.updateScript = nix-update-script { };

  patches = [ ./umask.patch ];

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
