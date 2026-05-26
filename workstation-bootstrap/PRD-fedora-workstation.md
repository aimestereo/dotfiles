---
title: "PRD — Fedora Workstation Setup"
summary: "End-to-end PRD for the Fedora Atomic Sway workstation: USB-bootstrap Tier-1, host package layer, terminals + theme, keyd Hyper-key remap, toolbox-as-outer Pattern B, xonsh interactive ergonomics (Mac zsh parity), per-project devpod containers, direnv/mise/devenv translation, Tailscale + AmneziaVPN networking, Flatpak GUI apps. Mac/Nix/devenv/zsh referenced only as baseline sources for replicated configs."
parent: "dotfiles-project-overview"
position: 0
---

# PRD — Fedora Workstation Setup

> Reference baselines (read-only spec, not modified by this PRD):
> - **Mac zsh** (`configs/shell/.zshrc` + `configs/shell/.config/zsh/zshrc-common`) — interactive shell behaviour source
> - **Mac brewfile / `nix/darwin/configuration.nix`** — host package inventory source
> - **devenv / Nix Home Manager** — per-project tooling pattern that mise mirrors inside devpod containers
> - **Karabiner `quad` Hyper mapping** (`configs/hammerspoon/.hammerspoon/quad-mapping.lua`) — CapsLock chord that keyd replicates

## Problem Statement

I want to set up a Fedora Atomic Sway PC as my primary workstation, side-by-side with my existing Mac. Goal: a single set of scripts + dotfiles that takes a freshly-installed Fedora Atomic machine to a fully working development environment — terminals, shell, editor, project containers, GPG, networking, GUI apps — with one bootstrap command and no manual second-step setup.

The shape of the solution has been worked out across ~20 closed DOT tasks and PKA-73's umbrella thread (architecture choices, tool selection, Pattern B toolbox-as-outer topology, xonsh Mac-zsh parity, devpod-per-project, USB bootstrap). This PRD consolidates those decisions into one durable spec so the actual buildout (and any rebuilds, on a second machine or after a wipe) starts from a single source of truth instead of re-deriving it from session history.

## Solution

A coherent, three-tier Fedora workstation that mirrors my Mac developer experience where it matters (shell reflexes, keymaps, tool integrations) and accepts intentional divergence where the platform demands it (rpm-ostree atomic upgrades, Sway/Wayland WM, starship over p10k):

- **Tier 1 — Host (rpm-ostree base + Flatpak GUI):** a fresh Fedora Atomic install can be bootstrapped from a USB stick via a single `curl | bash` line. Host shell is bash; host carries terminals (kitty, ghostty), input remap (keyd), brightness control, theme management, Tailscale, AmneziaVPN, and the Flatpak GUI apps I use daily.
- **Tier 2 — Toolbox `tools` (outer dev env):** ad-hoc shell work happens inside `toolbox enter tools` (manual; not auto-entered). A single `utils/install-personal-tools toolbox` script provisions all dev tools (mise, atuin, starship, claude, sd, git-delta, xonsh + xontribs, the `devpod` host wrapper). xonsh is the interactive shell, replicating Mac zsh reflexes. `pass` lives here.
- **Tier 3 — Devpod containers (per-project):** `devpod ssh fenix` from inside a toolbox tmux pane lands in the same xonsh interactive experience. `utils/install-personal-tools devpod` (same script, different mode) provisions the per-container personal stack. Project-specific tooling is handled by mise + direnv (devenv-on-Mac → mise-on-Fedora-devpod).

Reproducible from a fresh `make fedora-recreate-tools` on the host, and from a fresh `devpod up <project>` for any project. No manual second-step setup.

## User Stories

**Bootstrap and host:**

- Bootstrap the whole workstation from a USB stick via one `curl | bash` line, with no manual rpm-ostree pre-config.
- Re-running `make fedora-bootstrap` on an already-bootstrapped machine is idempotent — no errors on "already installed", no destructive rewrites.
- `make fedora-recreate-tools` rebuilds the `tools` toolbox from scratch and gives first entry the same shell experience as a fresh install — no manual second-step setup.
- Host-only targets (`make fedora`, `make fedora-bootstrap`, `make fedora-recreate-tools`) refuse to run from inside the toolbox with a clear message.

**Input, terminal, theme:**

- CapsLock acts as a Hyper key (quad chord — Cmd+Ctrl+Alt+Shift equivalent) globally, matching Karabiner-Elements on Mac.
- kitty and ghostty launch into the host bash prompt (not auto-enter the toolbox) and honor `~/.config/theme/current/` for palette.
- Inside the toolbox, `xterm-kitty` / `xterm-ghostty` terminfo resolves — no "terminfo entry not found" errors (DOT-28).
- `theme-set <name>` (or interactive picker) retargets all themed configs atomically and live-reloads running terminals (`SIGUSR1` kitty, `SIGUSR2` ghostty).
- `brightness-control` (ddcutil-backed) adjusts DDC/CI display brightness from the keyboard, with input-format validation.

**Shell reflexes inside toolbox + devpods (Mac zsh parity):**

- xonsh keybindings inside toolbox and every devpod match the Mac zsh setup — no reflex context-switch between machines.
- `toolbox enter tools` lands in xonsh directly — no manual `xonsh` step.
- `Ctrl-R` opens atuin's TUI on the first keypress in a fresh session — not readline's `I-search backward:`, not fzf's history widget.
- `Ctrl-P` / `Ctrl-N` (and `Up` / `Down`) with no text typed: previous / next history entry.
- With a typed prefix (e.g. `git ch`), `Ctrl-P` / `Up` steps backward through only history entries starting with the prefix, leaving the cursor in place — matching Mac zsh's `up-line-or-beginning-search`.
- In xonsh vi mode, history nav + autosuggest accept + atuin all work in insert mode (`i`) — no `$VI_MODE` toggle clobbers atuin's binding.
- `Ctrl-Y` over an autosuggestion accepts it (xonsh / zsh-autosuggestions equivalent).
- In vi-command mode, `Ctrl-V` edits the current line in nvim — matching Mac zsh's `bindkey -M vicmd '^v' edit-command-line`.
- `ls` / `cat` / `g` / `gst` / `v` and friends aliased identically to Mac.
- `listening [pattern]` and `pyclean` helpers available in xonsh — matching Mac equivalents.
- If xonsh is missing on a half-provisioned toolbox, atuin `Ctrl-R` still works via `atuin init bash` rather than vanilla readline.

**Browser dispatch from inside toolbox:**

- Any tool inside toolbox calling `xdg-open <url>` (gh, aws sso, slack URL clicks) opens the URL in the host browser via a `~/.local/bin/xdg-open` wrapper that shells out to `flatpak-spawn --host /usr/bin/xdg-open "$@"`.
- The host's default web browser is **Zen Browser**, bound declaratively by `utils/install-flatpaks` via `xdg-settings set default-web-browser app.zen_browser.zen.desktop`. Without that binding, host MIME defaults fall back to Firefox / the base-image default and URLs from toolbox open in the wrong browser.
- `gh auth login` inside toolbox completes via host browser (DOT-32).
- `aws sso login` inside toolbox completes via host browser; resulting `~/.aws/sso/cache/` session is visible to the toolbox (shared `$HOME`) and to every devpod (bind-mounted `~/.aws/`).

**Cross-machine clipboard + file send (Mac ↔ Fedora):**

- **LocalSend** (Flatpak) runs on host. LAN discovery + clipboard / file send between machines. Used for copying stacktraces and ad-hoc files from one machine to the other without a cloud round-trip. Lives on host (not toolbox) because it needs native Wayland clipboard, mDNS discovery, and notifications.

**Devpod per-project containers:**

- `devpod ssh <project>` lands in the same shell experience as the toolbox (xonsh, atuin, history nav, aliases, vi mode, mise, direnv).
- A project `.envrc` with `use devenv` (cross-platform) loads devenv when `devenv.yaml` is present, falls through to mise/PATH otherwise — same on Mac (devenv installed) and Fedora devpod (mise installed; devenv usually absent).
- Unified atuin history across host, toolbox, and devpods (single `~/.local/share/atuin/` on host, bind-mounted everywhere).
- zoxide: host + toolbox share the same DB (survives `toolbox rm` via shared `$HOME`); each devpod has its own container-local DB.
- `clone-and-go` clones a repo, opens a tmux session in it, and runs `devpod up` if `.devcontainer.json` is present.

**Git, networking, GUI apps:**

- `git diff` / `git log` paginate via delta — matching Mac's `[core] pager = delta`.
- `git push` works without ssh-agent inside the toolbox (passphrase-less SSH key).
- Tailscale on host for mesh networking; AmneziaVPN as a separate native installer for geo-restricted access.
- Flatpak GUI apps (Zen, Slack, Telegram, Zoom, LocalSend, Obsidian, Transmission, Calibre, mpv) installed declaratively via `utils/install-flatpaks`. Zen is bound as the default web browser as part of that script.

## Implementation Decisions

### Modules

- **USB Tier-1 bootstrap** — `workstation-bootstrap/`. `fedora-bootstrap.sh` + `README.md` + SSH key. `curl | bash` one-liner clones the dotfiles repo to `~/work/my/dotfiles`, registers COPRs, installs Tier-1 rpm-ostree packages, sets up Flathub remote, exits before reboot.

- **Host post-install** — `utils/fedora-after-install` (orchestrator) + `utils/install-flatpaks` (Tier-2 GUI apps + Zen default-browser binding) + `utils/install-amneziavpn` (Qt-installer tarball) + `utils/install-devpod` (vendor static binary to `/usr/local/bin/devpod`). Enforced host-only via `/run/.toolboxenv` guard.

- **Toolbox entry shell shim** — `configs/shell-fedora/.bashrc`. Bash entry hook: absolute-path exec to `~/.local/bin/xonsh`; atuin bash init as fallback if exec is skipped. Non-login-shell aware (toolbox enters bash without sourcing `/etc/profile.d/`).

- **xonsh interactive shell bundle** — `configs/xonsh/.config/xonsh/`:
   - `rc.xsh` — loader; iterates fixed sequence: `env.xsh → aliases.xsh → functions.xsh → tools.xsh → keybinds.xsh → prompt.xsh`. Load order is timing-sensitive. Uses `$XONSH_CONFIG_DIR` (XDG-aware). Each `source` wrapped in `_load` for fault isolation.
   - `env.xsh` — env vars, `$PATH` prepends, `$VI_MODE = True`, `$BROWSER = 'xdg-open'`.
   - `aliases.xsh` — Mac zsh alias parity (`l`, `ll`, `g`, `gst`, etc.).
   - `functions.xsh` — `pyclean`, `listening` (two-stage `subprocess.run` with `errors='replace'` to survive multi-byte truncation).
   - `tools.xsh` — tool integrations in order: zoxide → mise → carapace → direnv (xontrib) → fzf-widgets (xontrib) → atuin. Atuin loads last among prompt_toolkit-binding-affecting tools so its `Ctrl-R` binding wins (last registration wins in prompt_toolkit).
   - `keybinds.xsh` — custom prompt_toolkit bindings: `Ctrl-Y` (autosuggest accept), `Ctrl-P` / `Ctrl-N` (prefix-aware history backward / forward), `Up` / `Down` (same, but with `eager=True` + a `should_search`-matching filter so they win over atuin's `Keys.Up`), `Ctrl-V` in vi-command mode (open current buffer in `$EDITOR`). NO `$VI_MODE` toggle here.
   - `prompt.xsh` — starship integration.

- **Shared toolset provisioning** — `utils/install-personal-tools <toolbox|devpod>`. ONE script, two modes. Single source of truth for "tools I want everywhere":
   - **Shared (both modes)**: dnf package list (`git-delta`, `python3-pip`, `eza`, `bat`, `fzf`, `ripgrep`, `fd-find`, `zoxide`, `direnv`, `tmux`, `gh`, `awscli2`, `--skip-unavailable` for Fedora-version drift); curl installers (mise, atuin, starship, claude — via `curl -fsSL https://claude.ai/install.sh | bash`); upstream-binary install for `sd` (not in Fedora repos); xonsh user-pin + `xpip install -r utils/xontrib-requirements.txt`; idempotency check uses python3 + absolute paths (avoids the `command -v` before `export PATH` race).
   - **Toolbox-only**: `stow` (so `make symlinks-fedora` runs from inside toolbox), `flatpak-xdg-utils` (provides `flatpak-spawn` for the `devpod` wrapper), `pass`, terminfo mirror (`~/.terminfo/x/{xterm-kitty,xterm-ghostty}` copied from `/run/host/usr/share/terminfo` — DOT-28), `~/.local/bin/devpod` wrapper (`flatpak-spawn --host /usr/local/bin/devpod`), `~/.local/bin/xdg-open` wrapper (`flatpak-spawn --host /usr/bin/xdg-open "$@"` — absolute path mirrors the devpod wrapper's same-shape pattern) so any tool calling `xdg-open` opens URLs in the host browser.
   - **Devpod-only**: nothing yet; the shared baseline is sufficient.

- **Devpod per-project containers** — `utils/devcontainer-mounts.json` is the bind-mount reference snippet that each project's `.devcontainer.json` includes. Each project's `postCreateCommand` runs `/dotfiles-utils/install-personal-tools devpod` (the dotfiles repo's `utils/` is mounted into the container at `/dotfiles-utils:ro`). DevPod itself is installed on the host as a vendor static binary at `/usr/local/bin/devpod` (no rpm-ostree layering needed — `/usr/local` is a symlink to `/var/usrlocal` on rpm-ostree).

- **Window manager + input** — Sway (Atomic Sway base image). Input: `configs/keyd/.local/share/keyd/default.conf` (CapsLock → quad chord, mirroring Karabiner `quad-mapping.lua`); installed via `sudo cp` to `/etc/keyd/default.conf` in `fedora-after-install`.

- **Terminals + theme** — `configs/kitty/` and `configs/ghostty/` (host stow packages, include `~/.config/theme/current/{kitty,ghostty}.conf`); `configs/theme/` provides `theme-update` (clones omarchy renderer to `~/.local/share/omarchy`, renders all theme palettes), `theme-set-templates` (vendored from omarchy), and `theme-set` (retargets `current` symlink, sends `SIGUSR1`/`SIGUSR2` to live-reload running terminals). `~/.config/theme/` is runtime state, not tracked in repo.

- **Brightness** — `configs/brightness/.local/bin/brightness-control` (ddcutil DDC/CI, ACTION-format validation regex `^[+-][0-9]+$`).

- **Networking** — Tailscale (host rpm-ostree layer from Tailscale's RPM repo); AmneziaVPN (`utils/install-amneziavpn` — Qt-installer tarball extracted to `~/.local/opt/amnezia/` with `.desktop` shortcut).

- **Flatpak GUI apps** — `utils/install-flatpaks` (Tier-2): Zen (default web browser, bound via `xdg-settings`), Slack, Telegram, Zoom, LocalSend, Obsidian, Transmission, Calibre, mpv.

- **Cross-shell baseline reference** — `configs/shell/` (Mac zsh + cross-platform shell files); not modified by this PRD. The Mac zsh keybinding set is the spec; the Fedora xonsh bundle must mirror its visible behaviour.

### Key technical decisions

#### Tier-1 host bootstrap

- **USB-distributable `curl | bash` one-liner** is the entry point. Hosts the dotfiles repo path at `~/work/my/dotfiles` (DOT-15).
- **rpm-ostree atomic quirks**:
  - `rpm --import` removed — `/usr/share/rpm` is read-only on Atomic (DOT-16); RPM repos provide keys via their `.repo` files which rpm-ostree honors.
  - `--allow-inactive` on `rpm-ostree install` — for packages already provided by the base image (e.g. virtual `gnupg` is `gnupg2`) (DOT-17).
  - `--idempotent` — re-runnability without errors (DOT-20).
  - `--skip-unavailable` on dnf installs inside toolbox — Fedora-version drift (`git-delta` binary subpackage only ships from F42+; older Fedora has only the source `rust-git-delta` package).
- **COPR registrations** (must come before package installs): `alternateved/keyd` (DOT-18), `scottames/ghostty`.
- **Tier-1 rpm-ostree list** (host-only): `kitty ghostty git stow gnupg pinentry wl-clipboard qt5-qtwayland libnotify ddcutil tailscale keyd 1password 1password-cli` (no `xonsh`, `tmux`, `gcc` — those live in the toolbox).
- **`stow` in Tier-1** (DOT-19) — needed before `make symlinks-fedora` can run on the host.
- **`qt5-qtwayland`** (DOT-22) — Qt apps render natively on Wayland (AmneziaVPN, etc.).

#### Pattern B topology (toolbox-as-outer)

- **Terminals land on host bash**, not auto-entered into toolbox. User types `toolbox enter tools` manually (DOT-31 reverted the auto-enter ergonomics layer). Rationale: auto-enter via kitty/ghostty `command=` proved fragile (kitty `globinclude` requires relative paths; ghostty `conf.d` ordering; terminal restart broke during `toolbox rm`).
- **Toolbox = outer dev env**. ad-hoc shells, `pass`, `gh`, `git`, mise, atuin, xonsh, devpod wrapper. Not a sandbox; it's where I live for ad-hoc work.
- **Devpod = per-project**. `devpod ssh fenix` from inside a toolbox tmux pane. Each project gets a container with its own mise environment.
- **Tmux runs inside the toolbox**, not on host and not inside devpods. Workflow: kitty (host) → toolbox enter tools → tmux → sessionizer → `devpod ssh <project>` in panes.
- **The `~/.local/bin/devpod` wrapper** (`flatpak-spawn --host /usr/local/bin/devpod`) bridges toolbox→host DevPod CLI. Load-bearing for Pattern B; requires `flatpak-xdg-utils` dnf-installed in toolbox.
- **The `~/.local/bin/xdg-open` wrapper** (`flatpak-spawn --host /usr/bin/xdg-open`) bridges toolbox→host URL-dispatch (DOT-32, DOT-39). Same shape as the devpod wrapper; toolbox branch uses absolute `/usr/bin/xdg-open` to disambiguate from the wrapper itself. On host, PATH order shadows the system `xdg-open` with this wrapper; the wrapper's `else` branch falls through by absolute path — no recursion.

#### Shell stack on Fedora

- **bash → xonsh exec, not native xonsh**. Toolbox login shell stays bash (per `/etc/passwd`). `.bashrc` does an absolute-path exec into `~/.local/bin/xonsh` when present. Considered + rejected: `chsh` the user's shell to xonsh inside the toolbox image (toolbox is recreated frequently; chsh would couple shell-default to image-build flow).
- **Absolute-path test in `.bashrc`** (`[[ -x "$HOME/.local/bin/xonsh" ]]`), not `command -v xonsh` (DOT-36). `toolbox enter tools` spawns bash non-login, so `/etc/profile.d/local-bin.sh` doesn't run → `~/.local/bin` not on PATH → `command -v xonsh` returns non-zero → exec skipped.
- **`$VI_MODE = True` set in `env.xsh`, not `keybinds.xsh`**. Hypothesis was that toggling `$VI_MODE` AFTER `atuin init xonsh` registers its `Ctrl-R` binding (via `@events.on_ptk_create`) forces a PTK rebuild that drops atuin's handler — so setting `$VI_MODE` early would let atuin's binding survive. **Status: hypothesis did not fix the issue.** Atuin `Ctrl-R` still does not fire on first keypress in a fresh toolbox session. Root cause unknown; tracked as outstanding work.
- **xonsh load order**: `env.xsh → aliases.xsh → functions.xsh → tools.xsh → keybinds.xsh → prompt.xsh`. Tool inits run AFTER env (PATH includes `~/.atuin/bin`, `~/.local/bin`) and BEFORE custom keybindings (our `Ctrl-P` / `Ctrl-N` register last and win their slots; tools' bindings for other keys remain).
- **Within `tools.xsh`: fzf-widgets loads BEFORE atuin** (DOT-34). Both bind `Ctrl-R`. Last registered wins.
- **Atuin Ctrl-R via the atuin-emitted code, not custom**. `execx($(atuin init xonsh))` is canonical; emitted code uses `@events.on_ptk_create` + `bindings.add(Keys.ControlR)` with no vi/emacs filter (verified against atuin's `crates/atuin/src/shell/atuin.xsh`).
- **Prefix-aware history search for `Ctrl-P` / `Ctrl-N` / `Up` / `Down`** (DOT-39) via custom prompt_toolkit binding in `keybinds.xsh`. prompt_toolkit's `Buffer.history_backward()` only does prefix matching when `buf.enable_history_search()` returns True (xonsh's default is False). Implementation: flip `buf.enable_history_search` to `Always()` for the call, set `buf.history_search_text = None` so `_set_history_search` recomputes the prefix from the current cursor position on each keypress, delegate to `history_backward()` / `history_forward()`, then restore the filter, the saved `history_search_text`, and cursor position (the call jumps cursor to end-of-line; zsh's `up-line-or-beginning-search` keeps it in place). `Up` / `Down` carry `eager=True` plus a `_can_prefix_nav` Condition that mirrors atuin's `should_search` (`buf.complete_state is None and '\n' not in buf.text`). prompt_toolkit collapses to the eager set before applying last-registered-wins, so our binding wins over atuin's non-eager `Keys.Up` registration; with the filter False (active completion menu or multi-line buffer), Up/Down fall through to the default cursor / menu navigation.
- **Vi-command-mode `Ctrl-V` opens current buffer in `$EDITOR`** (DOT-39). `@bindings.add(Keys.ControlV, filter=vi_navigation_mode)` calling `Buffer.open_in_editor()`. Mirrors Mac zsh `bindkey -M vicmd '^v' edit-command-line`. Replaces the prompt_toolkit default vi visual-block binding (acceptable; visual block was never wired in the zsh side).
- **Autosuggest + syntax highlighting** rely on xonsh defaults (`$AUTO_SUGGEST = True`, `$COLOR_INPUT = True`). Not explicitly set in `env.xsh` — trusting framework defaults per the project's "don't add features beyond what's required" convention.
- **Atuin bash fallback** in `.bashrc` AFTER the xonsh exec block (DOT-37). Runs only if exec was skipped (xonsh missing / not executable). Provides `Ctrl-R` via `atuin init bash` so failure mode is degraded-but-usable rather than broken.

#### `install-personal-tools` script

- **Single script, two modes** (`toolbox` / `devpod`). Replaces the prior split (`devpod-container-bootstrap` + the planned-but-never-built `fedora-toolbox-provision`). Shared personal stack with mode-specific blocks.
- **Idempotency checks use absolute paths + python3 `rpm-ostree status --json`**, NOT `command -v <tool>`. Reason: `command -v atuin` runs before `export PATH=$HOME/.atuin/bin:$PATH` later in the script → returns non-zero → re-installs on every run. Same bug class hit mise.
- **`sd` from upstream binary** (chmln/sd GitHub release). Not in any Fedora repo. Same install pattern as mise/atuin/starship.
- **`python3-pip` and `stow` in toolbox dnf list**. pip needed for xonsh user-pin and xpip xontribs. stow needed so `make symlinks-fedora` can run from inside toolbox (host and toolbox share `$HOME`; convenient to be able to re-stow from either).
- **`flatpak-xdg-utils` in toolbox dnf list** — provides `flatpak-spawn` for the devpod + xdg-open host wrappers.
- **`awscli2` in shared dnf list** (DOT-39). With the xdg-open wrapper in place, `aws sso login` runs entirely inside toolbox; sessions land in `~/.aws/sso/cache/` and are auto-shared with host via shared `$HOME` and bind-mounted rw into every devpod.
- **`git-delta` from dnf** (F42+). `--skip-unavailable` makes it a no-op on older Fedora; user falls back to plain `less`.

#### Devpod bind-mount policy

`utils/devcontainer-mounts.json` is the canonical reference. Two principles:

- **Share configs and intentional state** (rw) — `~/.config/{xonsh,git,nvim,mise,atuin,tmux,shell}`, `~/.bashrc`, `~/.zshrc`, `~/.zshenv`, `~/.local/share/atuin/` (unified history), `~/.aws/` (SSO session cache; login runs on host, sessions visible to toolbox + every devpod), `~/work/my/dotfiles/utils → /dotfiles-utils:ro`.
- **DO NOT share installed binaries or caches** — `~/.local/bin` (host-only), `~/.local/share/mise/` (mise shims/binaries are arch-specific), `~/.local/share/nvim/` (shada path mismatch), `~/.local/share/zoxide/` (devpods get container-local zoxide DBs; **host's zoxide DB stays on host and is auto-shared with toolbox via the shared `$HOME`**, so `toolbox rm tools` doesn't wipe it), `~/.cache/`, `~/.ssh` (auth socket forwarded instead), `~/.gnupg` (separate signing agent).
- **rw by default, not readonly**. You need to be able to `:Lazy update` / `git commit --amend` / etc. from inside the container without it bouncing on read-only mounts.

#### Direnv + devenv (cross-platform; not Fedora-specific brokenness)

- **direnv is cross-platform.** On both Mac and Fedora the `.envrc` pattern is the same: `use devenv` if `devenv.yaml` exists in the repo, otherwise mise + plain PATH. The branch is selected by the presence of `devenv.yaml`, not by the host OS.
- **Mac side** has `devenv` installed (Nix-managed); `use devenv` activates the devenv shell.
- **Fedora devpod side** typically has `mise` for project tooling; if a project's `.envrc` calls `use devenv` and `devenv.yaml` is present but devenv isn't installed in the devpod, that project would need devenv added to the container's `install-personal-tools devpod` extension (per-project, not a global change).
- The xontrib `xonsh-direnv` is installed in both toolbox and devpod via the pinned xontrib requirements file; direnv itself comes from the dnf list.

#### Atuin / zoxide history sharing

- **atuin**: single `~/.local/share/atuin/` on host, bind-mounted into every devpod, also visible inside toolbox via shared `$HOME`. Unified history everywhere.
- **zoxide**: `~/.local/share/zoxide/` on host is auto-shared with toolbox (shared `$HOME`); survives `toolbox rm`. Devpods get container-local zoxide DBs (no bind mount) — per-project frecency makes sense per-container.

#### xontrib pinning

- **`utils/xontrib-requirements.txt`** (`xonsh-direnv==1.6.5`, `xontrib-fzf-widgets==0.0.4`) is the single source of truth, used by both `utils/mac-after-install` and `utils/install-personal-tools`. Pinned to prevent silent breakage when xontribs publish breaking releases.
- **xonsh itself is NOT in the requirements file** — Mac installs xonsh via brew; Fedora installs it via `pip install --user` pinned inline in `install-personal-tools`.

#### Networking + GUI apps

- **Tailscale** — host rpm-ostree layer (registered via Tailscale's RPM repo).
- **AmneziaVPN** — `utils/install-amneziavpn` extracts the Qt-installer tarball to `~/.local/opt/amnezia/` and writes a `.desktop` file. Forced workaround for a vendor that doesn't provide rpm/flatpak; not a template for other apps.
- **Cloudflare geo-block gotcha** — `mise.jdx.dev`, `claude.ai`, GH release CDN are Cloudflare-fronted and can geo-block from certain residential / ISP IPs (Russia in particular). Symptom: installer hangs indefinitely. Workaround: VPN. IPv4/IPv6 routing tweaks don't help.
- **Flatpak GUI** — `utils/install-flatpaks` runs `flatpak install --user flathub <id>` for: `app.zen_browser.zen`, `com.slack.Slack`, `org.telegram.desktop`, `us.zoom.Zoom`, `org.localsend.localsend_app`, `md.obsidian.Obsidian`, `com.transmissionbt.Transmission`, `com.calibre_ebook.calibre`, `io.mpv.Mpv`. Categorised as browser → communication → productivity → utilities.
- **Default web browser = Zen** (DOT-40). After the flatpak install, the script runs `xdg-settings set default-web-browser app.zen_browser.zen.desktop`. Without it, host MIME defaults resolve to Firefox / base-image default, which both `xdg-open` on host and the toolbox `xdg-open` wrapper inherit. The script prepends `~/.local/share/flatpak/exports/share` to `XDG_DATA_DIRS` immediately before the `xdg-settings` call so it can find Zen's desktop file in non-login shells where `/etc/profile.d/flatpak.sh` hasn't been sourced (a real scenario during fresh-boot TTY bootstrap).
- **LocalSend** (DOT-40) — Flatpak on host (`org.localsend.localsend_app`). LAN clipboard + file send between machines, used to move stacktraces / ad-hoc files between Mac and Fedora. Host-side because it requires Wayland clipboard, mDNS, and notifications. Mac symmetry is brew `--cask localsend`.

#### Make targets and host/toolbox enforcement

- **Host-only targets** (`make fedora`, `make fedora-bootstrap`, `make fedora-recreate-tools`, anything touching flatpak / rpm-ostree / systemd / podman) — refuse to run from inside toolbox via `/run/.toolboxenv` guard.
- **`make fedora-recreate-tools`** (DOT-41) — convenience for the toolbox-rebuild loop while iterating on `install-personal-tools` and the xonsh bundle. Sequence: host-only guard → `-podman rm --force tools` (Make `-` prefix tolerates absent container but keeps stderr for daemon failures; `--force` handles stop+remove in one) → `$(MAKE) fedora`. Goes directly to podman rather than `toolbox rm` because toolbox-metadata desync is the exact failure mode this target exists to recover from. Replaces the previous manual `toolbox rm tools && make fedora` pattern in the verification checklist.
- **Cross-context targets** (`make symlinks-fedora`) — runs from host OR toolbox (shared `$HOME`).
- **CLAUDE.md Installation table** annotates which target needs which context.

### Schema / contracts

- **`.bashrc`** contract: must work as both a login bash and a non-login interactive bash. Absolute paths only for binary references.
- **`rc.xsh`** contract: file list `('env.xsh', 'aliases.xsh', 'functions.xsh', 'tools.xsh', 'keybinds.xsh', 'prompt.xsh')` is the ordered load sequence; any new file added is appended (don't reorder existing entries without auditing tool-init timing).
- **`env.xsh`** contract: env vars and `$PATH` prepends only; no prompt_toolkit binding registrations. `$VI_MODE` set here.
- **`tools.xsh`** contract: tool-specific init in dependency order (PATH-providers first, prompt_toolkit-binding-providers last). Atuin must be the final `Ctrl-R` claimant.
- **`keybinds.xsh`** contract: custom bindings inside `@events.on_ptk_create`; never set `$VI_MODE` here.
- **`install-personal-tools`** contract: idempotent on re-run; cleans up any artifact previous versions wrote; uses absolute paths for tool-presence checks; `--skip-unavailable` on dnf install.
- **`utils/devcontainer-mounts.json`** contract: rw bind-mounts of configs/intentional-state; never bind-mounts arch-sensitive binaries or per-container caches.

## Testing Decisions

### Testing approach

Dotfiles config is not unit-testable in the traditional sense; the "system under test" is the running workstation. **Verification is manual hardware-test checklist** at three scopes:

```
# Tier 1 — Fresh OS bootstrap
# (after Fedora Atomic install + USB)
curl <bootstrap-url> | bash     # → idempotent; --idempotent for rerun
reboot                          # for rpm-ostree layer
make fedora                     # → host post-install (flatpaks, keyd, amnezia, devpod)
xdg-settings get default-web-browser   # → app.zen_browser.zen.desktop
flatpak list --user | grep localsend   # → org.localsend.localsend_app present
toolbox create tools && toolbox enter tools  # → bash prompt on host; toolbox provisions on first entry

# Tier 2 — Fresh toolbox recreation
make fedora-recreate-tools      # → stops + removes + re-provisions the `tools` toolbox
toolbox enter tools             # → bash → execs xonsh
# keystroke checklist:
#   Ctrl-R                           → atuin TUI opens
#   (type "git c") then Ctrl-P       → previous history entry starting with "git c"
#   (empty buffer) then Ctrl-P / N   → prev/next history entry
#   (empty buffer) then Up / Down    → prev/next history entry
#   (typed prefix) then Up / Down    → prefix-aware history search
#   (vi-cmd mode via Esc) then Ctrl-V → opens nvim with current buffer
#   Ctrl-Y on an autosuggestion      → accepts it
#   git diff HEAD~1                  → delta paginates
#   ssh -T git@github.com            → works without ssh-add
#   z <known-dir>                    → jumps (history preserved across toolbox rm)
#   gh auth login                    → opens Zen (not Firefox) on host
#   aws sso login                    → opens Zen on host; ~/.aws/sso/cache populated
#   xdg-open https://github.com      → opens Zen on host

# Tier 3 — Fresh devpod
devpod up fenix && devpod ssh fenix   # → bash → execs xonsh
# Same keystroke checklist; plus:
#   atuin history visible (unified with host)
#   zoxide DB empty (container-local; expected)
#   mise activated for project; direnv loads .envrc / devenv.yaml if present
```

### What makes a good test (per project conventions)

For non-trivial code we'd test functions with actual logic. For dotfiles, the only place this applies is `utils/install-personal-tools` and `utils/fedora-bootstrap.sh` (shell scripts) — and there the meaningful tests are:
- `bash -n` syntax check
- Idempotency: running the script twice on a fresh toolbox produces the same end state
- Cleanup correctness: artifacts written by previous versions are removed by the current version
- Host-only guard: targets that require host refuse to run from inside toolbox

### Modules to test

- **`install-personal-tools`** — `bash -n` syntax + idempotency.
- **`install-flatpaks`** — `bash -n` syntax + idempotency (flatpak install -y is no-op when present; xdg-settings set overwrites).
- **`workstation-bootstrap/fedora-bootstrap.sh`** — `bash -n` syntax + `--idempotent` re-run.
- **`fedora-after-install`** — host-only guard (`/run/.toolboxenv` check refuses execution from toolbox).
- **xonsh bundle** — no automated tests; manual keystroke checklist.
- **`shell-fedora/.bashrc`** — `bash -n`.

## Outstanding work (TODOs to deliver this PRD)

Sub-tasks expected to live as siblings of the DOT-38 tracking task. (Completed items have moved into the relevant "Implementation Decisions" section; their commit / DOT references are listed there.)

- **Fix atuin `Ctrl-R` not firing in fresh toolbox session (DOT-37 still in QA)** — moving `$VI_MODE = True` to `env.xsh` and adding the bash atuin fallback did not resolve it. Need a different diagnostic: trace what bindings PTK actually holds on first `@events.on_ptk_create` fire vs after the first prompt; check whether atuin's init even ran (script error swallowed?); test if a manual `execx($(atuin init xonsh))` from the live prompt installs the binding.
- **Switch toolbox login shell to xonsh** — `chsh` (or set in the toolbox image) so toolbox enters xonsh directly without the bash-exec dance. May resolve DOT-37 by removing the bash → xonsh transition entirely. Planned; not yet executed.
- **xonsh sanity script** — load rc files in headless mode and assert binding presence (`Keys.ControlR`, `Keys.ControlP`, `$VI_MODE` true, eager Up). Catches binding-pipeline regressions without manual keystroke testing. Deferred — manual checklist sufficient until rc files grow.
- **Sway WM bringup + theming** — Sway config, waybar (or alternative), application launcher (walker / rofi / fuzzel), notification daemon, swaylock/swayidle. Currently undecided; this PRD lists Sway as the WM but doesn't enumerate the config files.
- **Tailscale-to-Headscale** — if/when self-hosted Headscale becomes desirable, switch from public Tailscale coordination to private.
- **pinentry flavor** — GTK vs Qt vs curses for GPG inside toolbox; currently using base-image default.
- **DemoStand `.devcontainer.json` export** — DOT-24 leftover; deferred until needed.

## Explicit non-goals (will NOT do)

- **Mac side changes** — Mac zsh / brewfile / Nix darwin config is the reference baseline; this PRD doesn't propose changes there.
- **Automated shell behaviour tests beyond `bash -n`** — manual keystroke checklist is sufficient.
- **Cross-platform visual prompt parity** — Mac uses p10k, Fedora uses starship. Both work, both are themed; visual identity isn't a goal.
- **Per-devpod-container customisation in this repo** — the `install-personal-tools devpod` bundle is shared 1:1 between toolbox and every devpod; project-specific tooling lives in the project's own `.devcontainer/postCreateCommand` extension.
- **Migration of the entire Mac zsh `setopt` block** — only user-observable behaviours (history nav, vi mode, autosuggestions) are migrated; subtle interactive-shell flags that don't manifest as visible behaviour are not.
- **Sharing `~/.local/share/{mise,nvim,zoxide-on-devpod}` between containers** — arch/path mismatches break silently; per-container is intentional.
- **AmneziaVPN as a template for other Qt-installer apps** — forced workaround for one vendor, not a pattern.

## Further Notes

### Known fragility surface

- **prompt_toolkit binding lifecycle** is event-driven (`@events.on_ptk_create`) and depends on registration order. Bindings registered before a state change that triggers a rebuild are lost.
- **prompt_toolkit binding precedence** combines two rules: among matching bindings, last-registered-wins — UNLESS any match is `eager=True`, in which case prompt_toolkit collapses to just the eager set before applying last-wins. To win over an eagerly-loaded xontrib's binding (e.g. atuin's `Keys.Up`) without controlling load order, mark your binding `eager=True` and replicate the xontrib's filter so default behaviour stays intact when your binding shouldn't fire.
- **xonsh's env-var system** has subtle effects: changing `$VI_MODE`, `$SHELL_TYPE`, `$XONSH_INTERACTIVE` mid-session may rebuild the PTK shell.
- **bash's `.bashrc`** runs in different contexts (login vs non-login, interactive vs not) with different PATH states. Absolute paths are the robust idiom.
- **`pip install --user`** puts binaries in `~/.local/bin`, which is on PATH only via `/etc/profile.d/local-bin.sh` (login shells). Non-login interactive bash misses this.
- **`command -v <tool>` idempotency checks** in `install-personal-tools` run before `export PATH=...` later in the script → false negatives → re-install on every run. Use absolute paths.
- **`xdg-settings` and `XDG_DATA_DIRS`** — `xdg-settings set default-web-browser <id>.desktop` validates `<id>` against the desktop-file search path. For user-flatpak-installed apps that path is `~/.local/share/flatpak/exports/share`, added to `XDG_DATA_DIRS` only by `/etc/profile.d/flatpak.sh` at login. Non-login shells (fresh-boot TTY bootstrap, `bash <(curl ...)`) miss this and `xdg-settings` fails with "no such desktop file". Scripts that bind a Flatpak app as the default must prepend the path explicitly.
- **rpm-ostree atomic** — `--allow-inactive`, `--idempotent`, virtual-package resolution all matter; non-Atomic Fedora intuitions mislead.
- **Cloudflare geo-block** — `mise.jdx.dev`, `claude.ai`, GH release CDN can hang indefinitely from blocked IPs; VPN required.
- **kitty `globinclude` requires relative paths** (`globinclude conf.d/*.conf`, not `~/.config/kitty/conf.d/*.conf`). Now moot for the shell entry path (DOT-31 reverted the auto-enter) but the lesson lives in kitty.conf.

### Alternative directions considered

- **Move to bash + atuin bash + readline keybindings** (skip xonsh entirely on Fedora). Simpler stack, but loses xonsh's Python integration (`listening` / `pyclean` helpers, future-extensibility). Rejected.
- **Use zsh on Fedora too** (perfect Mac parity). Requires installing zsh in toolbox + every devpod container, and maintaining two parallel shell configs. Rejected — preserves the existing xonsh investment.
- **Build a custom toolbox image with xonsh as the user's login shell**. Cleanest from a "shell lifecycle" perspective; removes the bash-exec dance. Deferred until other toolbox-image needs accumulate.
- **Pattern A (host as outer)** — install dev tools on host, devpods optional. Rejected on hardware: missing atuin/fzf/zoxide/eza/bat on bare host gave a degraded shell experience; host-as-laboratory creates rpm-ostree pollution.
- **chezmoi instead of stow**. Stow's directory-as-package model maps directly to the `configs/*` layout. Rejected chezmoi.
- **Nix on Fedora** — declarative store appeal vs the Atomic host's own atomic upgrade story. Rejected; would double-manage what rpm-ostree already does.
- **Drop `Up` / `Down` from prefix-aware history nav** (Option A from DOT-39 review). Simpler — only `Ctrl-P` / `Ctrl-N` carry the binding, no eager+filter dance. Rejected in favour of Option B (eager + `should_search`-mirror filter) because Up/Down are explicit User Stories items and atuin's Up TUI is a distinct UX from inline prefix nav.
- **LocalSend in a dedicated toolbox container** (DOT-40 question from commander). Toolboxes don't expose Wayland clipboard, mDNS, or notifications without extra wiring; LocalSend's killer features would be broken. Rejected in favour of host-Flatpak (sandboxed via Flatpak, native desktop integration).
- **`xdg-settings` move to `fedora-after-install`** (suggestion from DOT-40 conventions lens). Architecturally cleaner separation, but splits the Zen-related host state across two scripts. Rejected in favour of locality — re-running `install-flatpaks` alone produces a complete, working setup.

### Out-of-band knowledge captured here

These facts are referenced in the implementation but worth surfacing once at the PRD level:

- The toolbox base image is Fedora; `toolbox enter` spawns bash from `/etc/passwd`'s shell field, **non-login**.
- `/etc/profile.d/local-bin.sh` adds `~/.local/bin` to PATH for login shells; non-login interactive shells inherit only the parent's PATH.
- `/etc/profile.d/flatpak.sh` adds `~/.local/share/flatpak/exports/share` to `XDG_DATA_DIRS` for login shells; non-login shells miss it. Any host script that calls `xdg-settings set default-web-browser <flatpak-app>.desktop` must prepend the path explicitly to be safe in fresh-bootstrap contexts.
- Atuin's xonsh init binds `Ctrl-R` without any vi/emacs filter AND `Keys.Up` with a `should_search` filter (`complete_state is None and '\n' not in buffer.text`) — verified at `https://github.com/atuinsh/atuin/blob/main/crates/atuin/src/shell/atuin.xsh`. Any custom Up binding must use `eager=True` + a matching filter to take precedence without breaking completion-menu navigation.
- `git-delta` binary subpackage exists in Fedora repos from F42 onwards; older Fedora has only the `rust-git-delta` source package.
- `sd` is not in any Fedora repo; install from chmln/sd GitHub release.
- The DOT-28 terminfo mirror (`~/.terminfo/x/{xterm-kitty,xterm-ghostty}` copied from host `/run/host/usr/share/terminfo`) is required because the toolbox base image's ncurses lacks these entries.
- DevPod is installed as a vendor static binary to `/usr/local/bin/devpod`. `/usr/local` is a symlink to `/var/usrlocal` on rpm-ostree — no rpm-ostree layering needed, writable on a live system, persists across base-image upgrades.
- Toolbox shares `$HOME` with host. Files created in either context are visible from the other.
- AmneziaVPN ships only as a Qt-installer tarball; `utils/install-amneziavpn` extracts and writes a `.desktop` shortcut.
- `xdg-utils` (providing `/usr/bin/xdg-open` and `/usr/bin/xdg-settings`) is part of every Fedora Atomic variant's base image as a desktop-stack dependency; the host-side dispatch path for the xdg-open wrapper and the default-browser binding are therefore reliable on all targeted hosts.
