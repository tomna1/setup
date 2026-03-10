{ config, pkgs, ... }:

{
  home.username = "thomas";
  home.homeDirectory = "/home/thomas";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    helix
    neovim
    git
    ripgrep
    fzf
    zoxide
  ];
}
