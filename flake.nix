{
  description = "Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, nixos-wsl, ... }:
    # supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    {

      homeConfigurations.samo = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        };
        modules = [
          ./users/samo/home.nix
        ];
      };

      nixosConfigurations =
        let
          # Shared config between both the liveimage and real system
          /* aarch64Base = {
            system = "aarch64-linux";
            modules = with self.nixosModules; [
              ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
              home-manager.nixosModules.home-manager
              traits.overlay
              traits.base
              services.openssh
            ];
          }; */
          Base_x64 = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
              home-manager.nixosModules.home-manager
              traits.overlay
              traits.base
            ];
          };
        in
        with self.nixosModules; {
          IsoImage = nixpkgs.lib.nixosSystem {
            inherit (Base_x64) system;
            modules = Base_x64.modules ++ [
              platforms.iso
            ];
          };
          medion = nixpkgs.lib.nixosSystem {
            inherit (Base_x64) system;
            modules = Base_x64.modules ++ [
              platforms.medion
              traits.machine
              traits.workstation
              traits.gnome
              users.samo
            ];
          };
          wsl = nixpkgs.lib.nixosSystem {
            inherit (Base_x64) system;
            modules = Base_x64.modules ++ [
              nixos-wsl.nixosModules.wsl
              platforms.wsl
              users.samo
            ];
          };
        };

      nixosModules = {
        platforms.container = ./platforms/container.nix;
        platforms.wsl = ./platforms/wsl.nix;
        platforms.medion = ./platforms/medion.nix;
        platforms.iso-minimal = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        platforms.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix";
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
        traits.base = ./traits/base.nix;
        traits.machine = ./traits/machine.nix;
        traits.wine = ./traits/wine.nix;
        traits.gnome = ./traits/gnome.nix;
        traits.sourceBuild = ./traits/source-build.nix;
        # This trait is unfriendly to being bundled with platform-iso
        traits.workstation = ./traits/workstation.nix;
        users.samo = ./users/samo;
      };

      checks = {
        format = pkgs.runCommand "check-format"
        {
          buildInputs = with pkgs; [ rustfmt cargo ];
        } ''
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
          touch $out # it worked!
          '';
      };

    };
}
