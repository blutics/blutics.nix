{ config, pkgs, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "ko_KR.UTF-8";
  console.keyMap = "us"; # 취향
  environment.systemPackages = with pkgs; [
    git neovim starship tree
  ];

}

