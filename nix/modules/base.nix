{ config, pkgs, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "ko_KR.UTF-8";
  console.keyMap = "us"; # 취향

  programs.zsh.enable = true; # 모든 호스트에 zsh 가능

  environment.systemPackages = with pkgs; [
    git vim starship
  ];

  # 로그인 쉘 초기화에서 starship 붙이기(전역)
  environment.interactiveShellInit = ''
    export TERM=xterm-256color
    export COLORTERM=truecolor
    eval "$(starship init zsh)"
  '';
}

