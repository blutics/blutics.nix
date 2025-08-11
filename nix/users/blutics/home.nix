{ config, pkgs, ... }:
{
  home.username = "blutics";
  home.homeDirectory = "/home/blutics";
  home.stateVersion = "24.11";

  # 사용자 전용 패키지
  home.packages = with pkgs; [
    zsh fzf bat eza ripgrep fd zoxide
    python311 nodejs unzip
    gnumake gcc
    rustc cargo
    nixd
    yazi lazygit
    tmux
    htop
  ]; 

  imports = [
    ./modules/shell.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
  ];
 
}

