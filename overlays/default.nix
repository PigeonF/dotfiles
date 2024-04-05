_: {
  additions = final: _: {
    committed = final.callPackage ./committed { };
    gitlab-ci-local = final.callPackage ./gitlab-ci-local { };
  };
}
