#!/usr/bin/env bash

set -euo pipefail

# Safe to run as:
#   curl -fsSL https://raw.githubusercontent.com/aimestereo/dotfiles/main/workstation-bootstrap/fedora-bootstrap.sh | bash
# Idempotent — re-runs skip already-completed steps.

dotfiles_repo="https://github.com/aimestereo/dotfiles.git"
dotfiles_dir="$HOME/work/my/dotfiles"

echo
echo "=== Fedora Atomic Sway bootstrap ==="
echo

# Tailscale's .repo file embeds the GPG key URL, so no separate rpm --import.
echo "[1/7] Registering Tailscale repo..."
curl -fsSL https://pkgs.tailscale.com/stable/fedora/tailscale.repo |
	sudo tee /etc/yum.repos.d/tailscale.repo >/dev/null

# Skip 'rpm --import' on Atomic: /usr/share/rpm/ is read-only. The .repo file's
# embedded gpgkey URL is enough — rpm-ostree fetches it at install time.
echo "[2/7] Registering 1Password repo..."
sudo tee /etc/yum.repos.d/1password.repo >/dev/null <<'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF

# keyd lives in COPR — the project's own README endorses alternateved/keyd.
# The .repo file uses $releasever/$basearch so it works across Fedora versions.
echo "[3/7] Registering keyd COPR repo..."
curl -fsSL https://copr.fedorainfracloud.org/coprs/alternateved/keyd/repo/fedora-/alternateved-keyd-fedora-.repo |
	sudo tee /etc/yum.repos.d/keyd.repo >/dev/null

# ghostty has no official Fedora repo; the scottames/ghostty COPR is the
# recommended source for Atomic variants per ghostty.org install docs.
echo "[4/7] Registering ghostty COPR repo..."
curl -fsSL https://copr.fedorainfracloud.org/coprs/scottames/ghostty/repo/fedora-/scottames-ghostty-fedora-.repo |
	sudo tee /etc/yum.repos.d/ghostty.repo >/dev/null

# --idempotent: already-requested packages are skipped instead of erroring,
# so re-running the script syncs the layer to match the list (Nix-style).
# --allow-inactive: packages already provided by the base (e.g. gnupg via
# gnupg2 on Sway Atomic) are recorded as requested but stay inactive instead
# of failing the transaction.
# Note: removals are NOT auto-handled. Drop a package from the list AND run
# `sudo rpm-ostree uninstall <pkg>` once to actually remove it.
# Host stays minimal per Pattern B (toolbox-as-outer): dev tools live in the
# `tools` toolbox, not on the host. xonsh, tmux, gcc were previously layered
# here — they now live only in the toolbox (installed by
# `utils/install-personal-tools toolbox`).
#
# `git` stays on host because this script needs it at [7/7] for the initial
# clone, and `git pull` needs to work without entering the toolbox for repo
# refreshes. `--allow-inactive` makes the line a no-op if Atomic Sway's base
# image already provides git.
echo "[5/7] Layering rpm-ostree packages (this takes a few minutes)..."
sudo rpm-ostree install -y --idempotent --allow-inactive \
	kitty \
	ghostty \
	git \
	gnupg \
	pinentry \
	stow \
	wl-clipboard \
	swayosd \
	mako \
	rofi \
	qt5-qtwayland \
	libnotify \
	ddcutil \
	tailscale \
	keyd \
	1password \
	1password-cli

# Flathub goes in here so the post-reboot `make fedora` step can install
# Tier-2 GUI flatpaks without a separate remote-add.
echo "[6/7] Adding Flathub user remote..."
flatpak remote-add --if-not-exists --user flathub \
	https://dl.flathub.org/repo/flathub.flatpakrepo

# Clone over HTTPS — no SSH key needed yet. Re-runs are no-ops if the
# directory is already a git checkout.
echo "[7/7] Cloning dotfiles into $dotfiles_dir..."
mkdir -p "$(dirname "$dotfiles_dir")"
if [[ -d "$dotfiles_dir/.git" ]]; then
	echo "  ($dotfiles_dir already a git checkout; skipping clone)"
else
	git clone "$dotfiles_repo" "$dotfiles_dir"
fi

# Move any distro-shipped ~/.bashrc out of the way so stow can land its own
# without a conflict. Skip if it's already a symlink (already stowed) or absent.
if [[ -f "$HOME/.bashrc" && ! -L "$HOME/.bashrc" ]]; then
	backup="$HOME/.bashrc.bak.$(date +%s)"
	mv "$HOME/.bashrc" "$backup"
	echo "  (backed up existing ~/.bashrc to $backup)"
fi

cat <<'EOM'

=== Tier 1 complete. ===

REBOOT now to activate the layered packages, then finish setup:

    cd ~/work/my/dotfiles
    make fedora

EOM
