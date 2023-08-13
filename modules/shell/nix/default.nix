{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      direnv
      nixpkgs-fmt
      rnix-lsp
    ];
  };
}
