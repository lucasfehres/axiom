{ pkgs, ... }:

# the macOS account is called lucasfehres instead of lucasf
{
  system.primaryUser = "lucasfehres";

  # required for nix-darwin to manage the login shell of an existing account
  users.knownUsers = [ "lucasfehres" ];
  users.users.lucasfehres = {
    uid = 501;
    home = "/Users/lucasfehres";
    shell = pkgs.nushell;
  };

  environment.shells = [ pkgs.nushell ];

  # existing dotfiles (e.g. from the Homebrew nushell) get moved aside instead of failing the switch
  home-manager.backupFileExtension = "hm-backup";

  home-manager.users.lucasfehres = {
    imports = [
      ./home.nix
    ];

    home.username = "lucasfehres";
    home.homeDirectory = "/Users/lucasfehres";
  };
}
