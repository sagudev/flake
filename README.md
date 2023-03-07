# flake

This repository contains the Nix / NixOS configuration for all of my systems. 

interesting:
- <https://nixos.wiki/wiki/Flakes#Using_nix_flakes_with_NixOS>
- <https://github.com/Hoverbear-Consulting/flake>
- <https://github.com/srid/nixos-config>
- <https://github.com/Misterio77/nix-starter-configs>

## Setup

To use this repository as base configuration for your new machine running:

### NixOS Linux

- Install NixOS
  - Hetzner dedicated from Linux Rescue system: https://github.com/serokell/nixos-install-scripts/pull/1#pullrequestreview-746593205
  - Digital Ocean: https://github.com/elitak/nixos-infect
  - X1 Carbon: https://srid.ca/x1c7-install
  - Windows (via WSL): https://github.com/nix-community/NixOS-WSL
- Clone this repo at `/etc/nixos`
- Edit `flake.nix` to use your system hostname in the `nixosConfigurations` set
- Edit `users/config.nix` to contain your users
- Run `nix develop -c , activate`. That's it. Re-open your terminal.

## Architecture

Start from `flake.nix` (see [Flakes](https://nixos.wiki/wiki/Flakes)). [`flake-parts`](https://flake.parts/) is used as the module system. 

### Directory layout 

- `home`: home-manager config
- `modules`: nix modules for X (aka. traits)
- `users`: user information
- `systems`: top-level configuration.nix for various systems

## Tips

- Run `,` in `nix develop` shell (tip: direnv is better) to see available scripts.
  - (`,` is provided by the [mission-control](https://github.com/Platonic-Systems/mission-control) module)
- To update NixOS (and other inputs) run `nix flake update`
  - You may also update a subset of inputs, e.g.
      ```sh
      nix flake lock --update-input nixpkgs --update-input darwin --update-input home-manager
      # Also, in the dev shell: , update-primary
      ```
- To free up disk space,
    ```sh-session
    sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +2
    sudo nixos-rebuild boot
    ```
- To autoformat the project tree using nixpkgs-fmt, run `nix fmt`.

intereting webgpu test: https://iohk.io