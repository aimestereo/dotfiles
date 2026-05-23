# Fedora Atomic Sway — workstation bootstrap

Step-by-step setup for a fresh Fedora Sway Atomic install. This directory belongs on a USB stick alongside your SSH key.

## 0. Prepare the USB

Copy this `workstation-bootstrap/` directory onto a USB stick alongside your private SSH key files (e.g., `id_ed25519` + `id_ed25519.pub`). **The SSH key is NOT checked into the dotfiles repo — bring your own.**

## 1. Install Fedora Sway Atomic

Boot the official installer, complete OOBE, log in.

## 2. Tier-1 bootstrap

```bash
cp -r /run/media/$USER/<USB_LABEL>/workstation-bootstrap ~/
cd ~/workstation-bootstrap
chmod +x fedora-bootstrap.sh
./fedora-bootstrap.sh
```

Layers the base packages at the rpm-ostree base layer:

| Package | Purpose |
|---|---|
| kitty | GPU-accelerated terminal |
| tmux | Terminal multiplexer |
| xonsh | Python-powered shell (Fedora interactive default) |
| git | Version control |
| gnupg, pinentry | GPG / SSH auth |
| gcc | Compile-time deps for some user-space tooling |
| wl-clipboard | Wayland clipboard utilities |
| tailscale | Mesh VPN (system service) |
| keyd | CapsLock → Hyper key remap (system service) |
| 1password, 1password-cli | GUI + CLI (via 1Password's vendor RPM repo) |

Then adds the Flathub remote (user scope) so the subsequent `make fedora` step can install GUI flatpaks without a separate remote-add.

**Reboot afterwards** — rpm-ostree layered packages become available only after a fresh boot.

## 3. Add your SSH key

```bash
cp /run/media/$USER/<USB_LABEL>/id_ed25519{,.pub} ~/.ssh/
chmod 600 ~/.ssh/id_ed25519
```

## 4. Clone dotfiles

```bash
mkdir -p ~/projects/my
git clone git@github.com:aimestereo/dotfiles.git ~/projects/my/dotfiles
cd ~/projects/my/dotfiles
```

## 5. Pre-stow cleanup

Fedora ships a default `~/.bashrc`; GNU Stow refuses to overwrite. Back it up before symlinking:

```bash
mv ~/.bashrc ~/.bashrc.bak
```

(Skip if already absent from a previous setup attempt.)

## 6. `make fedora`

```bash
make fedora
```

Runs in order:

1. `utils/symlinks-fedora` — stows Fedora-relevant config packages (skips `hammerspoon`, `nix`)
2. `utils/install-flatpaks` — Tier-2 GUI apps: Zen, Slack, Telegram, Zoom, Obsidian, Transmission, Calibre, mpv
3. `utils/install-amneziavpn` — AmneziaVPN binary into `~/.local/opt/amnezia/`
4. `utils/install-devpod` — DevPod CLI into `/usr/local/bin/`
5. Pinned xonsh xontribs (via `utils/xontrib-requirements.txt`)
6. Toolbox container `tools` + `pass` inside it
7. keyd config copied to `/etc/keyd/`, service enabled and (re)started

## 7. Smoke test

```bash
xonsh -i                          # interactive xonsh works
tmux new -d                       # tmux session works
amnezia &                         # AmneziaVPN launchable
devpod --version                  # DevPod on PATH
toolbox run -c tools pass --help  # pass works inside Toolbox
systemctl status keyd             # keyd active
tailscale status                  # Tailscale wired
1password &                       # 1Password GUI launches
```

If anything fails, check `journalctl --user -n 50` (or the specific service's logs) and re-run the relevant `utils/install-*` script standalone.
