FROM nixos/nix

RUN nix-channel --update

RUN nix-shell -p git --run "git clone https://github.com/NicolasGermann/nvim_config ~/.config/nvim"
RUN nix-shell -p git --run "git clone https://github.com/NicolasGermann/helix_config ~/.config/helix"
RUN nix-shell -p git --run "git clone https://github.com/NicolasGermann/zellij_config ~/.config/zellij"


CMD ["nix-shell", "-p", "zellij", "helix", "neovim"]
