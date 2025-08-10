{ pkgs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ./hardware-configuration.nix    # ← 이 줄이 핵심
  ];
  users.users.blutics = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    # 방법 1) 해시 직접 기입
    hashedPassword = "$6$R4u6SBYYnhIi7Rfg$smXFFZctROdTTwuv7QB/rKSj175gobv0EqNuYgwtWXmQgGiK6OxgU68GKp68ZPkGpVAvI/9Zx1yQa/aJj0coc.";
    # 방법 2) 파일로 불러오기(권장: 시크릿 도구와 함께)
    # hashedPasswordFile = "/run/secrets/blutics.pwhash";
  };

  # 선언적 사용자 고정까지 원하면
  # users.mutableUsers = false;
  networking.hostName = "blutics";

  # 하나만 택하세요 (EFI vs BIOS)
  # EFI 부팅:
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # BIOS(레거시) 부팅이라면 위 두 줄 대신:
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sda";  # 실제 디스크로 수정

  # 경고 제거
  system.stateVersion = "24.11";
}

