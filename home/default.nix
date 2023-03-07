{ self, inputs, config, ... }:
{
  flake = {
    homeModules = {
      common = {
        home.stateVersion = "22.11";
        imports = [
          ./tmux.nix
          ./neovim.nix
          ./starship.nix
          ./terminal.nix
          ./direnv.nix
        ];
      };
      common-linux = {
        imports = [
          self.homeModules.common
          ./vscode-server.nix
        ];
        programs.bash.enable = true;
      };
      common-darwin = {
        imports = [
          self.homeModules.common
          ./emacs.nix
        ];
      };
    };
  };
}
