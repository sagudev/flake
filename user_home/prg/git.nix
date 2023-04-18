{ pkgs, config, flake, ... }:
{
  home.packages = [ pkgs.git-lfs ];

  programs.git = {
    enable = true;
    userName = "sagudev";
    userEmail = "16504129+sagudev@users.noreply.github.com";
    aliases = {
      co = "checkout";
      ci = "commit";
      cia = "commit --amend";
      s = "status";
      st = "status";
      b = "branch";
      # p = "pull --rebase";
      pu = "push";
    };
    extraConfig = {
      # "main" is only 4 chars instead of "master" (6 letters) or "trunk" (5 letters)
      defaultBranch = "main"; # https://srid.ca/unwoke
      core.editor = "nano";
      #protocol.keybase.allow = "always";
      credential.helper = "store --file ~/.git-credentials";
      pull.rebase = "false";
      # For supercede
      core.symlinks = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      # This looks better with the kitty theme.
      gui.theme = {
        lightTheme = false;
        activeBorderColor = [ "white" "bold" ];
        inactiveBorderColor = [ "white" ];
        selectedLineBgColor = [ "reverse" "white" ];
      };
    };
  };
}
