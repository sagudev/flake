# Support code for this repo. This module could be made its own external repo.
{ self, inputs, config, ... }:
{
  flake = {
    # Linux home-manager module
    nixosModules.home-manager = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        ({
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
            flake = { inherit config; };
          };
        })
      ];
    };
    lib = {
      mkLinuxSystem = mod: inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # Arguments to pass to all modules.
        specialArgs = {
          inherit system inputs;
          flake = { inherit config; };
        };
        modules = [ mod ];
      };
    };
  };

  perSystem = { system, config, pkgs, lib, ... }: {
    mission-control.scripts = {
      update-primary = {
        description = ''
          Update primary flake inputs
        '';
        exec =
          let
            inputs = [ "nixpkgs" "home-manager" ];
          in
          ''
            nix flake lock ${lib.foldl' (acc: x: acc + " --update-input " + x) "" inputs}
          '';
      };

      activate = {
        description = "Activate the current configuration for local system";
        exec =
          ''
            ${lib.getExe pkgs.nixos-rebuild} --use-remote-sudo switch -j auto
          '';
        category = "Main";
      };

      fmt = {
        description = "Autoformat repo tree";
        exec = "nix fmt";
      };
    };
  };
}
