{
  description = "TUI session manager for zmx";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f (import nixpkgs {inherit system;}));
  in {
    packages = forEachSystem (pkgs: {
      default = self.packages.${pkgs.system}.zsm;
      zsm = pkgs.buildGoModule {
        pname = "zsm";
        version = "0.1.0";
        src = ./.;

        vendorHash = "sha256-ObIKdIvZ0TLBGC2C25MH1WnaqS+B0YhJmfUzCMrlgG8=";

        ldflags = [
          "-s"
          "-w"
        ];

        meta = with pkgs.lib; {
          description = "TUI session manager for zmx";
          homepage = "https://github.com/mdsakalu/zmx-session-manager";
          license = licenses.mit;
          mainProgram = "zsm";
          platforms = platforms.unix ++ platforms.darwin;
        };
      };
    });

    devShells = forEachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          go_1_25
        ];

        inputsFrom = [self.packages.${pkgs.system}.zsm];
      };
    });
  };
}
