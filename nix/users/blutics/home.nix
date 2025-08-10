{ config, pkgs, ... }:
{
  home.username = "blutics";
  home.homeDirectory = "/home/blutics";
  home.stateVersion = "24.11";

  imports = [
    ./modules/shell.nix
    ./modules/neovim.nix
  ];

  # 사용자 전용 패키지
  home.packages = with pkgs; [
    fzf bat eza ripgrep fd
  ];

  programs.eza = {
    enable = true;
  }
  programs.zsh.initExtra = ''
    alias ls="eza --icons --group-directories-first -F"
    alias ll="eza -lah --icons --git"
    alias lt="eza -T --icons -L 2"
  ''
}

