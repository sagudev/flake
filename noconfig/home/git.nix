{ pkgs, config, ... }:
{
  home.packages = [ pkgs.git ];

  programs.git = {
    enable = true;
    userName = "sagudev";
    userEmail = "16504129+sagudev@users.noreply.github.com";
    aliases = {
      # p = "pull --rebase";
    };
    extraConfig = {
      # "main" is only 4 chars instead of "master" (6 letters) or "trunk" (5 letters)
      defaultBranch = "main";
      core.editor = "nano";
      #protocol.keybase.allow = "always";
      credential.helper = "${
        pkgs.git.override { withLibsecret = true; }
      # TODO: set passwd repo https://github.com/jordanisaacs/dotfiles/tree/master
      }/bin/git-credential-libsecret";
    };
  };
}
