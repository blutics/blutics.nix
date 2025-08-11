{ config, pkgs, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "ko_KR.UTF-8";
  console.keyMap = "us"; # 취향
  environment.systemPackages = with pkgs; [
    zsh git neovim starship tree
    tmux stow
  ];
  programs.zsh.enable = true;
  programs.tmux.enable = false;
  # environment.interactiveShellInit = ''
  # export TERM=xterm-256color
  # export COLORTERM=truecolor
  # eval "$(starship init zsh)"
  # '';

}

