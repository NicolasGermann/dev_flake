{
  description = "A development environment with Zellij and Helix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    helix-config = {
      url = "github:nicolasgermann/helix_config";
      flake = false;
    };
    zellij-config = {
      url = "github:nicolasgermann/zellij_config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, helix-config, zellij-config }: let
    # Helper function: build shell for any supported system
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  in {
    devShells = forAllSystems (system: let
      pkgs = import nixpkgs { inherit system; };

      # Basis-Shell
      baseShell = pkgs.mkShell {
        buildInputs = [
          pkgs.zellij
          pkgs.helix
          pkgs.neovim
        ];

        shellHook = ''
          mkdir -p "$(pwd)/.config/helix"
          mkdir -p "$(pwd)/.config/zellij"
          export XDG_CONFIG_HOME="$(pwd)/.config"

          # Copy configs into local .config directory
          cp -r ${helix-config}/. "$XDG_CONFIG_HOME/helix/"
          cp -r ${zellij-config}/. "$XDG_CONFIG_HOME/zellij/"
        '';
      };
    in {
      default = baseShell;

      dotnet = pkgs.mkShell {
        buildInputs = baseShell.buildInputs ++ [
          pkgs.dotnet-sdk
          pkgs.omnisharp-roslyn
        ];
      };

      python = pkgs.mkShell {
        buildInputs = baseShell.buildInputs ++ [
          pkgs.python3
        ];
      };

    });
  };
}
