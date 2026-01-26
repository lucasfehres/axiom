{ configName }:
let
  flake = builtins.getFlake (toString ./..);
  pkgs = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config = { };
    overlays = [ ];
  };
in
pkgs.testers.runNixOSTest {
  name = "test-${configName}";

  nodes.machine = {
    imports = flake.lib.testableConfigModules.${configName} ++ [
      ./secrets/dummy-secrets.nix
    ];
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("systemctl --failed")
  '';
}
