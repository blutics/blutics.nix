{ config, pkgs, ... }:
{
  home.username = "blutics";
  home.homeDirectory = "/home/blutics";
  home.stateVersion = "24.11";

  imports = [
    #./modules/shell.nix
    #./modules/neovim.nix
  ];

  # 사용자 전용 패키지
  home.packages = with pkgs; [
    fzf bat eza ripgrep fd
  ];

  programs.eza = {
    enable = true;
  };

  programs.zsh = {
    enable = true;                           # ← 세미콜론
    initExtra = ''
      alias ls="eza --icons --group-directories-first -F"
      alias ll="eza -lah --icons --git"
    '';                                      # ← 닫고 세미콜론
  };
programs.starship = {
  enable = true;

  settings = {
    username = {
    show_always = true;
    style_user = "bold green";
    style_root = "bold red";
    format = "[$user]($style) ";
  };
    add_newline = false;
    format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$jobs$character";
    character = { success_symbol = "❯"; error_symbol = "✗"; };
  };
};
}

