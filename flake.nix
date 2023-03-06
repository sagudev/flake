{
  description = "Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager }:
    # supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    {

      packages = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ self.overlays.default ];
        config.allowUnfree = true;
      };

      homeConfigurations.samo = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
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
          x86_64Base = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
              home-manager.nixosModules.home-manager
              traits.overlay
              traits.base
              services.openssh
            ];
          };
        in
        with self.nixosModules; {
          x86_64IsoImage = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.iso
            ];
          };
          honeycombIsoImage = nixpkgs.lib.nixosSystem {
            inherit (aarch64Base) system;
            modules = aarch64Base.modules ++ [
              platforms.iso
              traits.honeycomb_lx2k
              {
                config = {
                  virtualisation.vmware.guest.enable = nixpkgs.lib.mkForce false;
                  services.xe-guest-utilities.enable = nixpkgs.lib.mkForce false;
                };
              }
            ];
          };
          gizmo = nixpkgs.lib.nixosSystem {
            inherit (aarch64Base) system;
            modules = aarch64Base.modules ++ [
              platforms.gizmo
              traits.honeycomb_lx2k
              traits.machine
              traits.workstation
              traits.gnome
              traits.hardened
              users.samo
            ];
          };
          architect = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.architect
              traits.machine
              traits.workstation
              traits.gnome
              traits.hardened
              traits.gaming
              users.samo
            ];
          };
          nomad = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.nomad
              traits.machine
              traits.workstation
              traits.gnome
              users.samo
            ];
          };
          medion = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.medion
              traits.machine
              traits.workstation
              traits.gnome
              users.samo
            ];
          };
          wsl = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              nixos-wsl.nixosModules.wsl
              platforms.wsl
              users.samo
            ];
          };
        };

      nixosModules = {
        platforms.container = ./platforms/container.nix;
        platforms.wsl = ./platforms/wsl.nix;
        platforms.gizmo = ./platforms/gizmo.nix;
        platforms.architect = ./platforms/architect.nix;
        platforms.nomad = ./platforms/nomad.nix;
        platforms.iso-minimal = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        platforms.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix";
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
        traits.base = ./traits/base.nix;
        traits.machine = ./traits/machine.nix;
        traits.gaming = ./traits/gaming.nix;
        traits.gnome = ./traits/gnome.nix;
        traits.sourceBuild = ./traits/source-build.nix;
        traits.honeycomb_lx2k = ./traits/honeycomb_lx2k.nix;
        # This trait is unfriendly to being bundled with platform-iso
        traits.workstation = ./traits/workstation.nix;
        users.samo = ./users/samo;
      };

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          format = pkgs.runCommand "check-format"
            {
              buildInputs = with pkgs; [ rustfmt cargo ];
            } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out # it worked!
          '';
        });

    };
}
