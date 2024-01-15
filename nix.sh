# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# curl -L https://nixos.org/nix/install | sh

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

cd nix

# WARN: not repeatable command, use `nix profile upgrade 0`
nix profile install .

