{ pkgs, flake, ... }: {

  # Firewall
  networking.firewall.enable = true;

  security.sudo.execWheelOnly = true;

  security.auditd.enable = true;
  security.audit.enable = true;

  nix.settings.allowed-users = [ "root" "@users" ];
  nix.settings.trusted-users = [ "root" flake.config.people.myself ];
}
