{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true; # ← 세미콜론
    initExtra = ''
      export TERM=xterm-256color
       export COLORTERM=truecolor
       eval "$(starship init zsh)"

       alias ls="eza --icons --group-directories-first -F"
       alias ll="eza -lah --icons --git"
       alias fcd='sel=$(fd --type d --hidden --exclude .git . | fzf) && [ -n "$sel" ] && cd "$sel"'
       alias gd='cd "$(git rev-parse --show-toplevel)"' # git 프로젝트의 루트로 이동
       alias vf='f=$(fd --type f --hidden --exclude .git . | fzf) && [ -n "$f" ] && nvim "$f"'
       alias nrs="sudo nixos-rebuild switch --flake"
       cd ~
    ''; # ← 닫고 세미콜론
  };
  # 로그인 쉘 초기화에서 starship 붙이기(전역)

  programs.git = {
    enable = true;
    userName = "Daegun Kim";
    userEmail = "blutics@gmail.com";
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = false;
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
      character = {
        success_symbol = "❯";
        error_symbol = "✗";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.fzf.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = false;
  };

  programs.yazi.enable = true;
}
