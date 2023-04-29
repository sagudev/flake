# flake

This repository contains the Nix / NixOS configuration for all of my systems. 

interesting:
- <https://github.com/jammus/dotfiles>
- <https://nixos.wiki/wiki/Flakes#Using_nix_flakes_with_NixOS>
- <https://github.com/Hoverbear-Consulting/flake>
- <https://github.com/srid/nixos-config>
- <https://github.com/Misterio77/nix-starter-configs>
- <https://github.com/gvolpe/nix-config/blob/master/README.md>
- main idea has very similar concept to <https://github.com/malloc47/config>
- <https://codeberg.org/imMaturana/dotfiles/src/branch/main>
- <https://github.com/ifd3f/infra/blob/main/flake.nix>
- <https://github.com/bbigras/nix-config>

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
- Run `nix develop -c , activate`. That's it. Re-open your terminal.

### Directory layout 

- `hosts`: top-level configuration.nix for various systems/hosts
- `modules`: nix modules for X (aka. traits)
  - `home` Reusable home-manager modules you might want to export
  - `nixos` Reusable nixos modules you might want to export
  - `overlays` Your custom packages and modifications, exported as overlays 
  - `*.nix` Other custom traits & loaders (collections of commonwelth)
- `noconfig`: home(-manager) config (user config really)

## Tips

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

## Ideal

I would have nix system that can be deployed to WSL, containers and machines (armv7, x86, x86_64) with ability to run multipass/lxd for easy ubuntu like experience, but having it packed in full modular nix.

The only real contender to this would be popos cosmic written in rust.

or maybe not if I can get it working in nix: https://github.com/NixOS/nixpkgs/issues/199563

or https://github.com/numtide/system-manager on pop os

Well https://guix.gnu.org/ is direct contender to nix but it is currently ...


Off-topic: intereting webgpu test: https://iohk.io
