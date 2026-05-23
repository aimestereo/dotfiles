#!/usr/bin/env bash

set -euo pipefail

# Tier 1: register vendor repos (Tailscale, 1Password), layer all base
# packages in one rpm-ostree transaction, then add the Flathub user remote.
# Reboot is required afterwards for the layered packages to take effect.

# Tailscale repo — the .repo file embeds the GPG key URL, no separate import.
curl -fsSL https://pkgs.tailscale.com/stable/fedora/tailscale.repo |
	sudo tee /etc/yum.repos.d/tailscale.repo >/dev/null

# 1Password repo + GPG key.
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo tee /etc/yum.repos.d/1password.repo >/dev/null <<'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF

# Single rpm-ostree transaction covers Fedora base packages + both vendor RPMs.
sudo rpm-ostree install -y \
	kitty \
	tmux \
	xonsh \
	git \
	gnupg \
	pinentry \
	gcc \
	wl-clipboard \
	tailscale \
	keyd \
	1password \
	1password-cli

# Flathub user remote so the post-reboot `make fedora` step can install Tier-2
# GUI flatpaks without an extra remote-add.
flatpak remote-add --if-not-exists --user flathub \
	https://dl.flathub.org/repo/flathub.flatpakrepo

echo
echo "Tier 1 complete. Reboot now, then clone the dotfiles repo and run 'make fedora'."
