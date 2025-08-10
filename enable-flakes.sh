#!/usr/bin/env bash
# enable-flakes.sh
# 목적: nix-command + flakes 영구 활성화 (WSL/일반 리눅스/ NixOS 대응)
set -euo pipefail

usage() {
  cat <<'USAGE'
사용법:
  ./enable-flakes.sh            # 사용자 단위(~/.config/nix/nix.conf)에 설정
  sudo ./enable-flakes.sh --global   # 전역(/etc/nix/nix.conf)에 설정 (비-NixOS 권장)
  sudo ./enable-flakes.sh --nixos    # NixOS: 모듈 생성 후 rebuild 안내

옵션:
  --global  : /etc/nix/nix.conf 에 설정(비-NixOS/WSL에서 권장)
  --nixos   : NixOS 전용. /etc/nixos/enable-flakes.nix 모듈 생성(안전)
USAGE
}

FEATURE_LINE='experimental-features = nix-command flakes'

is_nixos() {
  command -v nixos-version >/dev/null 2>&1
}

write_user_conf() {
  local conf="$HOME/.config/nix/nix.conf"
  mkdir -p "$(dirname "$conf")"
  if [[ -f "$conf" ]] && grep -q '^experimental-features' "$conf"; then
    # 기존 라인 교체
    sed -i.bak -E "s/^experimental-features.*/$FEATURE_LINE/" "$conf"
  else
    echo "$FEATURE_LINE" >> "$conf"
  fi
  echo "[OK] 사용자 설정에 적용: $conf"
}

write_global_conf() {
  local conf="/etc/nix/nix.conf"
  sudo mkdir -p /etc/nix
  if [[ -f "$conf" ]] && grep -q '^experimental-features' "$conf"; then
    sudo sed -i.bak -E "s/^experimental-features.*/$FEATURE_LINE/" "$conf"
  else
    echo "$FEATURE_LINE" | sudo tee -a "$conf" >/dev/null
  fi
  echo "[OK] 전역 설정에 적용: $conf"

  # nix-daemon 사용 환경이면 재시작 시도(없어도 무시)
  if systemctl list-unit-files 2>/dev/null | grep -q nix-daemon; then
    sudo systemctl restart nix-daemon || true
    echo "[i] nix-daemon 재시작 시도 완료"
  fi
}

write_nixos_module() {
  # NixOS에서는 nix.conf를 직접 만지지 말고 모듈로 관리하는 편이 안전함
  local mod="/etc/nixos/enable-flakes.nix"
  sudo tee "$mod" >/dev/null <<EOF
{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
EOF
  echo "[OK] 모듈 생성: $mod"

  # configuration.nix에 import 안내
  local cfg="/etc/nixos/configuration.nix"
  echo
  echo "다음 중 하나를 수행하세요:"
  echo "  1) $cfg 의 imports 목록에 아래 줄 추가:"
  echo "       imports = [ ./enable-flakes.nix ... ];"
  echo "  2) 또는 flake에서 modules 배열에 ${mod} 경로를 포함"
  echo
  echo "적용:"
  echo "  sudo nixos-rebuild switch"
}

verify() {
  echo
  echo "=== 검증 ==="
  if nix --version >/dev/null 2>&1; then
    nix --version
    echo
    echo "설정 확인:"
    nix config show | grep -E '^experimental-features|experimental-features ='
    echo
    echo "flake 명령 테스트:"
    nix flake --help >/dev/null && echo "[OK] flake 서브커맨드 사용 가능"
  else
    echo "[!] nix 명령을 찾지 못했습니다. 먼저 nix를 설치하세요."
  fi
}

main() {
  if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage; exit 0
  fi

  if is_nixos && [[ "${1:-}" == "--nixos" ]]; then
    write_nixos_module
    verify
    exit 0
  fi

  case "${1:-}" in
    --global)
      write_global_conf
      ;;
    "" )
      write_user_conf
      ;;
    * )
      echo "[!] 알 수 없는 옵션: $1"
      usage; exit 1
      ;;
  esac

  verify
}

main "$@"

