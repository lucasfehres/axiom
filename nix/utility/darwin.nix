{ pkgs, ... }:

# nix-darwin counterpart of general.nix
{
  environment.systemPackages = [
    pkgs.git
    pkgs.ragenix
    pkgs.dig
  ];

  time.timeZone = "Europe/Amsterdam";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

  # This option defines the first version of nix-darwin used on this machine.
  # Do NOT change this value, see https://nix-darwin.github.io/nix-darwin/manual/#opt-system.stateVersion
  system.stateVersion = 6;
}
