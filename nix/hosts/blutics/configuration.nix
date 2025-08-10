{ pkgs, ... }:
{
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
}

