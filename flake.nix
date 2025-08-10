{
  description = "NixOS + Home Manager mono-repo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    # 개발용 공통 쉘(선택)
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [ pkgs.git pkgs.just ];
    };

    nixosConfigurations = {
      blutics = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nix/modules/base.nix
          # 필요 시 아래에서 선택
          # ./nix/modules/desktop.nix
          # ./nix/modules/server.nix

          #./nix/hosts/blutics/hardware.nix
          ./nix/hosts/blutics/configuration.nix

          # Home Manager 결합
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bluitcs = import ./nix/users/blutics/home.nix;
          }
        ];
      };
    };
  };
}

