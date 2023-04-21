{ pkgs, config, ... }:
{
  home.packages = [ pkgs.vscode ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    userSettings = { # login and sync to github
      "terminal.integrated.fontSize" = 16;
      "editor.fontSize" = 18;
      "editor.formatOnSave" = true;
    };
  };
}
