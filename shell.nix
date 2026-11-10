let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.11";
  pkgs = import nixpkgs {
    config = { };
    overlays = [ ];
  };
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    nixfmt-rfc-style
    ragenix

    # CI tooling (see ci/README.md); keep in sync with the recipes in the justfile
    curl
    fluxcd
    jq
    just
    kind
    kubeconform
    kubectl
    kustomize
    kyverno
    kyverno-chainsaw
    yq-go
  ];
}
