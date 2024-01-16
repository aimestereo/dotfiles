# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# curl -L https://nixos.org/nix/install | sh

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# WARN: not repeatable command, use `nix profile upgrade 0`
nix profile install .

#
# NIX home-manager
#
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# drop default config, it will be symlinked by stow
rm ~/.config/home-manager/home.nix
