_: {
  additions = final: _prev: {
    committed = final.callPackage ./committed { };
    gitlab-ci-local = final.callPackage ./gitlab-ci-local { };
  };
}
