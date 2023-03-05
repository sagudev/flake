{ config, pkgs, lib, ... }:

{
  home.username = "samo";
  home.homeDirectory = "/home/samo";
  home.sessionVariables.GTK_THEME = "palenight";


  programs.git = {
    enable = true;
    userName = "sagudev";
    userEmail = "16504129+sagudev@users.noreply.github.com";
    extraConfig = {
      init = {
        # "main" is only 4 chars instead of "master" (6 letters) or "trunk" (5 letters)
        defaultBranch = "main";
      };
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Use `dconf watch /` to track stateful changes you are doing, then set them here.
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "dash-to-panel@jderose9.github.com"
      ];
      favorite-apps = [ "firefox.desktop" "code.desktop" "org.gnome.Terminal.desktop" "virt-manager.desktop" "org.gnome.Nautilus.desktop" ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # enable-hot-corners = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Main" ];
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${./nix.jpg}";
      picture-uri-dark = "file://${./nix.jpg}";
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.dash-to-panel
    firefox
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    userSettings = {
      "workbench.colorTheme" = "Palenight Operator";
      "terminal.integrated.scrollback" = 10000;
      "terminal.integrated.fontFamily" = "Jetbrains Mono";
      "terminal.integrated.fontSize" = 16;
      "editor.fontFamily" = "Jetbrains Mono";
      "telemetry.telemetryLevel" = "off";
      "remote.SSH.useLocalServer" = false;
      "editor.fontSize" = 18;
      "editor.formatOnSave" = true;
    };
  };

  xdg.configFile."libvirt/qemu.conf".text = ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';

  programs.home-manager.enable = true;
  home.stateVersion = "22.11";
}
