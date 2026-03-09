{
  description = "My dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        helix
        git
        ripgrep
        zoxide
       	fzf
      ];
    };
  };
}
