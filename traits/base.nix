/*
  A trait for all boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    time.timeZone = "Europe/Ljubljana";
    # Windows wants hardware clock in local time instead of UTC
    #time.hardwareClockInLocalTime = true;

    i18n.defaultLocale = "sl_SI.UTF-8";
    i18n.supportedLocales = [ "all" ];

    environment.systemPackages = with pkgs; [
      # Shell utilities
      direnv
      nix-direnv
      git
      wget
      curl
      nano
      ripgrep
      lsof
      htop
      fd
      sd
      fio
      hyperfine
      tokei
      ntfs3g
      killall
      gptfdisk
      rnix-lsp
    ];
    environment.shellAliases = { };
    environment.pathsToLink = [
      "/share/nix-direnv"
    ];

    programs.bash.promptInit = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    programs.bash.shellInit = ''
    '';
    programs.bash.loginShellInit = ''
      HAS_SHOWN_NEOFETCH=''${HAS_SHOWN_NEOFETCH:-false}
      if [[ $- == *i* ]] && [[ "$HAS_SHOWN_NEOFETCH" == "false" ]]; then
        ${pkgs.neofetch}/bin/neofetch --config ${../config/neofetch/config}
        HAS_SHOWN_NEOFETCH=true
      fi
    '';
    programs.bash.interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      source "${pkgs.fzf}/share/fzf/key-bindings.bash"
      source "${pkgs.fzf}/share/fzf/completion.bash"
    '';

    # Use edge NixOS.
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # nix.package = pkgs.nixUnstable;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    nixpkgs.config.allowUnfree = true;

    # Hack: https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.systemd-udevd.restartIfChanged = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?
  };
}
