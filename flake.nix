{
  description = "Global CLI environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.default = pkgs.buildEnv {
      name = "cli-env";
      paths = with pkgs; [
        helix
        git
        neovim
        ripgrep
        fd
        nodejs
        python311
      ];
    };
  };
}
