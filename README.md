flake를 먼저 설정해야한다고 생각했다. 그래서 flake를 설정하는 shell코드를 만들었음.
하지만 그 이전에 코드를 git을 통해서 해당 머신으로 클론하는게 먼저인데 이를 위해서는
flake가 설정이 되어야한다.

/etc/nixos/configuration.nix
아래의 코드를 configuration.nix에 추가하여 git을 설치해준다.

`nix

  environment.systemPackages = with pkgs; [ git ];
` 

sudo nixos-rebuild switch --flake .#blutics


--`bash

nix-channel --list
# 비어 있거나 nixos 채널이 없으면 추가
nix-channel --add https://nixos.org/channels/nixos-24.05 nixos
nix-channel --update

nix-env -iA nixos.git
`

이 내용으로 git을 설치하는 bash를 만들면 되는거잖어.
