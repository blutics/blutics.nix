{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;

    mouse = true;
    baseIndex = 1;
    keyMode = "vi";
    terminal = "tmux-256color";
    escapeTime = 10;
    historyLimit = 100000;

    # nixpkgs에 있는 플러그인만 사용 → 재빌드 때 네트워크 안 탐
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
      prefix-highlight
      {
        plugin = catppuccin;
        extraConfig = ''
          ##### Catppuccin
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"

          # 상태바 전체 배경/전경
          set -g @catppuccin_status_background '#282c34'
          set -g @catppuccin_status_foreground '#000000'

          display -p "catppuccin middle"

          # 분리자 (오타 수정: sepa**r**ator)
          set -g @catppuccin_status_left_separator  ""
          set -g @catppuccin_status_right_separator "█ "

          # 윈도우 라벨 커스텀
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_current_text " #W \uedc6 "

          ##### Status line
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""


          set -g  status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          set -ag status-right "#{E:@catppuccin_status_date_time}"

          display -p "catppuccin complete"
          '';
      }
    ];

    # tmux 기본 옵션 + Catppuccin 변수들 (네가 준 conf를 이식)
    extraConfig = ''
      ##### Basic
      set -g status-position top
      set -s set-clipboard 'on'
      set -g renumber-windows 'on'

      # truecolor
      set -ga terminal-overrides ",*:RGB"

      ##### Resurrect / Continuum

      ##### Reload key
      bind r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded"

      display-message "hello world"
      display -p "world hello"
    '';
  };

  # 홈에 실제 파일도 남기고 싶다면(선택):
  # home.file.".tmux.conf".text = config.programs.tmux.extraConfig;
}

