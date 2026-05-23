# Fedora Atomic Sway — bootstrap

## One-line install

After a fresh Fedora Sway Atomic install + first boot, open a terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/aimestereo/dotfiles/main/workstation-bootstrap/fedora-bootstrap.sh | bash
```

The script:

- Registers the Tailscale, 1Password, and `alternateved/keyd` (COPR) RPM repos
- Layers all base packages — `kitty`, `tmux`, `xonsh`, `git`, `gnupg`, `pinentry`, `gcc`, `stow`, `wl-clipboard`, `tailscale`, `keyd`, `1password`, `1password-cli` — in one `rpm-ostree` transaction
- Adds the Flathub remote (user scope)
- Clones the dotfiles repo into `~/work/my/dotfiles` (HTTPS — no SSH key needed yet)
- Backs up any pre-existing distro `~/.bashrc` so stow can land its own

It's idempotent: re-running syncs the host layer to the manifest in the script. The rpm-ostree call uses `--idempotent` (already-requested packages are no-ops) plus `--allow-inactive` (base-provided packages stay inactive instead of erroring). After the initial curl|bash run, the more ergonomic re-sync path is `make fedora-bootstrap` from inside the dotfiles repo.

**Removals aren't auto-handled.** If you drop a package from the script's manifest, the package stays layered until you run `sudo rpm-ostree uninstall <pkg>` once.

## Reboot + finish

```bash
cd ~/work/my/dotfiles
make fedora
```

This runs `utils/symlinks-fedora` (stows the Fedora-relevant config packages) followed by `utils/fedora-after-install`:

1. Flatpaks: Zen, Slack, Telegram, Zoom, Obsidian, Transmission, Calibre, mpv
2. AmneziaVPN Qt installer staged at `~/.local/opt/amnezia/`; run it once to complete install (wizard sets up its own launcher)
3. DevPod CLI into `/usr/local/bin/`
4. Pinned xonsh xontribs
5. Toolbox `tools` container + `pass`
6. `keyd` config copied to `/etc/keyd/`, service enabled + (re)started

## Smoke test

```bash
xonsh -i                          # interactive xonsh works
tmux new -d                       # tmux session works
# AmneziaVPN: run ~/.local/opt/amnezia/*Installer*.bin once, then launch from app menu
devpod --version                  # DevPod on PATH
toolbox run -c tools pass --help  # pass works inside Toolbox
systemctl status keyd             # keyd active
tailscale status                  # Tailscale ready
1password &                       # 1Password GUI launches
```

If anything fails, `journalctl --user -n 50` (or the specific service's logs) and re-run the relevant `utils/install-*` script standalone.

## Enable git push (SSH)

The bootstrap clones over HTTPS, which is read-only against your repo. To push:

```bash
ssh-keygen -t ed25519 -C "$USER@$(hostname)"
cat ~/.ssh/id_ed25519.pub  # register at https://github.com/settings/keys
cd ~/work/my/dotfiles
git remote set-url origin git@github.com:aimestereo/dotfiles.git
```

## Forks

The script's clone source and target are constants at the top of `fedora-bootstrap.sh`. Forks should edit `dotfiles_repo` / `dotfiles_dir` directly and serve the script from their own raw URL.
