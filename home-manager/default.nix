_:

{
  config = {
    flake = {
      homeModules = {
        pigeon = _: {
          imports = [
            ../users/common
            {
              home = {
                username = "pigeon";
                homeDirectory = "/home/pigeon";
                stateVersion = "24.05";
              };
            }
          ];
        };
      };
    };
  };
}
