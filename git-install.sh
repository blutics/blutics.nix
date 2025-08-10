nix-channel --list
# 비어 있나 nixos 채널이 없으면 추가
nix-channel --add https://nixos.org/channels/nixos-24.05 nixos
nix-channel --update

nix-env -iA nixos.git          # 표준 Git
