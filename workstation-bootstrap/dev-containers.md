# Dev containers — day-to-day usage

How to live inside per-project DevPod containers without losing the dotfiles experience. Assumes `make fedora` has run successfully on the host (see `workstation-bootstrap/README.md`).

## Mental model — Pattern B: toolbox is the outer environment

```
Fedora Atomic host  ← MINIMAL launcher (rpm-ostree)
  ├─ GUI:    kitty, ghostty, flatpaks, 1Password, Tailscale, AmneziaVPN
  ├─ System: keyd, gnupg, pinentry, ddcutil, wl-clipboard, stow, …
  ├─ DevPod CLI: /usr/local/bin/devpod (manages the podman containers)
  └─ kitty/ghostty `command = toolbox enter tools` → drops straight into …
       │
       └─ toolbox `tools`  ← DEV ENV (one shared outer)
            ├─ dnf:  tmux, neovim, git, fzf, ripgrep, fd-find, sd, bat, eza,
            │        zoxide, tree, jq, gh, direnv, pass, xonsh, flatpak-xdg-utils
            ├─ curl: mise, atuin, starship, claude
            ├─ ~/.local/bin/devpod (wrapper → flatpak-spawn --host real binary)
            └─ devpod manages one container per project repo:
                 ├─ container: fenix     (multi-stack: Node + Python + Go)
                 └─ container: DemoStand (Compose-based)
```

The host is intentionally minimal — no dev shells, no editors, no language toolchains. The `tools` toolbox is the outer dev environment; per-project DevPod containers are inner, project-specific environments. Both the toolbox and every per-project container are provisioned by the same script (`utils/install-personal-tools`) so commander's personal CLI stack is the same everywhere.

> Historical note: an earlier "Pattern A" tried to put the dev toolchain on the host directly. That contradicted the original Fedora Atomic plan ("host minimal, dev in containers") and broke in practice (atuin / eza / bat / fzf / zoxide were assumed-present by the shell config but never installed on host). Pattern B restores the original intent.

## Workflow

1. Open kitty / ghostty → kitty's `shell` directive (or ghostty's `command`) drops you straight into the `tools` toolbox → bashrc execs xonsh → full dev shell, all tools on PATH.
2. `tmux-sessionizer` (inside toolbox) → pick `fenix` → tmux session is created or switched, cwd is the project root.
3. In that tmux session:
   - Pane 1: `devpod ssh fenix` → drops into the fenix container → `nvim` runs there with fenix's Node + LSP.
   - Pane 2: `devpod ssh fenix` again → **same container, second SSH session** → `npm run dev`.
   - Pane 3: stays in toolbox → `gclean`, `git push`, log tailing, ad-hoc shell. The toolbox is the "host-side" pane in Pattern B.
4. To switch projects, `tmux-sessionizer` again, pick another project, repeat.

`devpod` invoked from inside toolbox routes through `~/.local/bin/devpod` → `flatpak-spawn --host /usr/local/bin/devpod` so the real DevPod binary on host gets the call (podman lives on host).

DevPod containers persist across reboots. `devpod up <project>` after a cold start resumes the existing container fast; only a config change forces a rebuild.

## What lives where

| Concern | Host | Toolbox `tools` | DevPod container |
|---|---|---|---|
| GUI launchers (kitty, ghostty) | ✓ | — | — |
| DevPod CLI binary | ✓ (`/usr/local/bin/devpod`) | wrapper (`~/.local/bin/devpod` → host) | — |
| Shell, prompt (xonsh, starship) | — (xonsh unlayered) | ✓ | ✓ |
| Session orchestration (tmux, tmux-sessionizer) | — | ✓ | — (one tmux session spans all attaches) |
| Editor (nvim) | — | ✓ | ✓ (per-project LSP / runtime) |
| Generic CLI (fzf, ripgrep, eza, bat, zoxide, jq, gh) | — | ✓ | ✓ |
| History (atuin) | — | ✓ (shared DB via $HOME) | ✓ (shared DB via bind-mount) |
| Language runtimes (Node, Python, Go, …) | — | — | ✓ (via project `.mise.toml`) |
| System services (keyd, tailscale, podman) | ✓ | — | — |
| Secrets manager (1Password) | ✓ | — (calls via host) | — (calls via SSH agent forward) |

## Inside the container — what to expect

### Shell

`devpod ssh` drops you into bash, which immediately `exec`s into `xonsh -i` (see `configs/shell-fedora/.bashrc`). You're in xonsh by default; bash is still available as a sub-shell via `bash`. Login shell stays bash so `/etc/profile` and PAM continue to work.

### tmux

`~/.config/tmux/` is bind-mounted with the TPM plugin tree, so `tmux` works inside the container if you want per-project session isolation. The default Pattern B workflow keeps tmux in the toolbox (the outer layer); containers are attached to via `devpod ssh` and the same toolbox tmux session spans every attach.

### nvim

`~/.config/nvim/` is bind-mounted (rw). `~/.local/share/nvim/` is **not** mounted — plugins compile per-platform (treesitter parsers, telescope-fzf-native), and host vs container ABI mismatch corrupts them. First `nvim` launch inside the container bootstraps Lazy and compiles plugins; expect 15–60s on a fresh container. Plugin updates (`:Lazy update`) stay container-local.

### zoxide

By default, zoxide's frecency DB is container-local: starts empty, lost on container rebuild. To persist per-project across rebuilds, opt in via the named-volume Escape hatch below — frecency then survives rebuilds and stays scoped to the project (fenix's `z` history does not bleed into DemoStand's).

### mise

`~/.config/mise/` is bind-mounted (rw); the global `config.toml` inside it is intentionally empty (`[tools]` with no entries). Each project ships its own `.mise.toml` at the repo root; mise's standard precedence resolves project-local first, then global. Container `mise install` realises whichever versions the project declares.

### git

`~/.config/git/` is bind-mounted (rw) so identity and ignore rules carry over. `git push` works via DevPod's SSH agent forward — provided the host has `ssh-agent` running with the key loaded (`ssh-add -l` to verify; see Troubleshooting). The key itself never enters the container, and the container image must never bake one in.

### atuin

`~/.local/share/atuin/` is bind-mounted (rw). Command history unifies host + every container, so `Ctrl+R` surfaces hits regardless of where you ran them. atuin config (`~/.config/atuin/`) is mounted too.

> **Caveat:** any secret typed inline at any shell on any machine sharing this history store (`TOKEN=abc curl …`, `psql postgres://user:pw@host/db`) becomes readable from every other container with rw on the mount. Use env files or password managers; never paste secrets at the prompt.

### Host-only tools

`~/.local/bin/` is **not** mounted. Toolbox-side scripts (process control, networking, session orchestration, git workspace helpers) stay in the toolbox where they have their dependencies. Under Pattern B the container pane runs the project's runtime; git operations and session orchestration happen in the toolbox pane.

## Mount design principle

> Share configs and intentional state (history); never share installed binaries or caches across the host/container ABI boundary.

The current mount list (`utils/devcontainer-mounts.json`) is the application of this principle. The survey below records why each XDG category is included or excluded — future edits should respect the rationale rather than re-litigate.

### `~/.cache/` — ephemeral, regenerable

| Subdir | Mounted? | Reason |
|---|---|---|
| `nvim/`, `mise/`, `pip/`, `go-build/` | NO | Regenerable; ABI-specific |
| `fontconfig/`, `mesa_shader_cache/` | NO | Host GUI stack |
| `devpod/` | NO | Host-only (DevPod is the manager) |
| `atuin/`, `starship/` | NO | Tiny, regenerable |

**Default: nothing under `~/.cache/`.** Escape hatch (package-manager caches if rebuilds get painful) below.

### `~/.local/share/` — durable intentional state

| Subdir | Mounted? | Reason |
|---|---|---|
| `atuin/` | YES rw | Unified command history |
| `zoxide/` | NO by default; opt-in named volume | Container-local default; opt in via Escape hatch for per-project persistence |
| `mise/` | NO | Installed runtimes, ABI mismatch |
| `nvim/` | NO | Plugins compile per-platform |
| `applications/`, `icons/`, `fonts/` | NO | Host GUI |
| `flatpak/`, `containers/` | NO | Host package/runtime stores |
| `keyd/`, `direnv/` | NO | Host-only (Item 13 / Phase 1 carry-overs) |
| `xonsh/` | NO | atuin supersedes xonsh's own JSON history |

### `~/.local/state/` — env-specific durable state

| Subdir | Mounted? | Reason |
|---|---|---|
| `nvim/` (shada, undo, oldfiles) | NO | shada stores absolute file paths; host path `~/work/ablt/fenix/src/foo.ts` ≠ container path `/workspaces/fenix/src/foo.ts`. Marks/oldfiles become dead links; undo files keyed on content + path. Sharing breaks both sides. |
| `bash/`, `zsh/`, `xonsh/` | NO | atuin supersedes |
| `atuin/` | NO | Sync metadata; container-local is fine |

### Security boundary

`~/.ssh/` and `~/.gnupg/` are **never** bind-mounted. SSH auth flows through DevPod's SSH agent forwarding (host `ssh-agent` socket exposed to the container — no key on disk). GPG is **not** auto-forwarded by DevPod; signed-commit and pinentry operations stay on the host by default. If a project specifically needs gpg-agent inside the container, configure socket forwarding explicitly (out of scope for this doc).

**Every rw config bind-mount is a potential container-to-host escalation vector.** A compromised container can rewrite the mounted config; the host runs that config on the next launch of the tool that reads it. The bind-mount model trades container isolation for cross-environment portability — accepted because the threat model assumes images you trust enough to run. Notable specific vectors in the current mount list:

- **Shell rc files + tool configs** (`~/.bashrc`, `~/.zshrc`, `~/.zshenv`, `~/.config/{xonsh,nvim,tmux,shell}/`) — highest severity. Direct arbitrary code execution on the host's next launch of bash, zsh, xonsh, nvim, or tmux; a malicious `init.lua` runs next time you open `nvim` on the host.
- **Pattern B kitty / ghostty overrides** (`~/.config/kitty/conf.d/`, `~/.config/ghostty/local/`) — same class as shell rc. The Fedora-only `shell` / `command` directives are written by `install-personal-tools toolbox`; a compromised toolbox can rewrite them and intercept the next terminal launch on host.
- **`~/.config/git/`** — rewrites `core.sshCommand` to a malicious binary, or `url.<base>.insteadOf` to redirect remotes. Auth/transport hijack on the next host `git` operation.
- **`~/.config/mise/`** — appends tool entries; the host's next `mise install` (or `mise activate` hook on `cd`) pulls malicious shims into `~/.local/share/mise/shims/`.
- **`~/.local/share/atuin/`** — secret leak (separate class). History is bidirectional; container reads host history and writes its own back. The atuin caveat above applies to every container.

If a workflow seems to need bind-mounted secrets, fix the workflow.

## Escape hatch — per-project named DevPod volumes

Add a named volume when slow `npm install` / `pip install` rebuilds start to hurt, or to persist zoxide frecency across rebuilds. Volume name interpolates the workspace folder basename so each project gets its own. Named volumes are designed to outlive containers and DevPod machines; remove them explicitly with `docker volume rm devpod-<project>-<suffix>`.

The reference snippet in `utils/devcontainer-mounts.json` uses leading-comma authoring so individual entries can be uncommented without editing neighbours. The fully assembled form in the project's `.devcontainer.json` looks like:

```jsonc
"mounts": [
  // ... bind mounts from utils/devcontainer-mounts.json ...

  // Per-project zoxide DB (opt-in persistence)
  ,"source=devpod-${localWorkspaceFolderBasename}-zoxide,target=/home/${env:USER}/.local/share/zoxide,type=volume"

  // Package-manager caches (uncomment any that hurt on rebuild)
  ,"source=devpod-${localWorkspaceFolderBasename}-npm,target=/home/${env:USER}/.npm,type=volume"
  ,"source=devpod-${localWorkspaceFolderBasename}-pip-cache,target=/home/${env:USER}/.cache/pip,type=volume"
]
```

> **Caveat:** a poisoned package install in one container run can persist into every subsequent rebuild via the cache volume. If a build pulls something untrusted, `docker volume rm` the cache volume before the next rebuild.

## Per-project `.devcontainer.json`

`.devcontainer.json` is hand-authored — devenv has no command that emits one from `devenv.nix`. (The container subcommand is `devenv container {build,copy,run}`; there is no `generate`.) Three reasonable starting points:

- **No devenv at runtime** *(default for this dotfiles workflow)* — pin a plain Linux base (`docker.io/library/fedora:<tag>@sha256:<digest>`), install OS packages via `onCreateCommand` (`dnf -y install ...`), and let `mise install` (run by `/dotfiles-utils/install-personal-tools devpod`) resolve languages and devops tools from a per-project `.mise.toml`. Translate `devenv.nix` env block into `containerEnv`. Fastest to reason about and matches the dotfiles bootstrap script. See `~/projects/ablt/fenix/.devcontainer.json` for a worked example.
- **Upstream cachix image** — set `"image": "ghcr.io/cachix/devenv/devcontainer@sha256:<digest>"`. The image ships Nix + devenv preinstalled; inside the container, enter the project's environment with `devenv shell --from path:./<devenv-dir>`. Zero build step, but devenv runs at every shell entry.
- **Project-specific OCI image** — define `containers.<name>` in `devenv.nix`, then on the build host:

  ```bash
  devenv container build shell                                 # produces an OCI image
  devenv container copy shell --registry docker-daemon://      # load into local daemon
  # or push: devenv container copy shell --registry docker://ghcr.io/<owner>/
  ```

  Then set `"image"` in `.devcontainer.json` to the resulting tag. Tools are baked in, no devenv at runtime, faster container start, but the image must be rebuilt and redistributed on every `devenv.nix` change.

Either way, merge in the dotfiles bits from `utils/devcontainer-mounts.json`:

- `mounts` block (12 bind mounts + any per-project named volumes)
- `postCreateCommand: /dotfiles-utils/install-personal-tools devpod`

Project-specific fields the snippet does not provide:

- `image` or `build` — picked per the choice above
- `runArgs` — privileged flags, network mode, and per-port publish lines (see "Port routing" below for the loopback-IP pattern)
- `forwardPorts` — only if you want DevPod/VS Code to bind to `127.0.0.1`; the loopback-IP pattern uses `runArgs --publish` instead
- `containerEnv` — project env vars
- `customizations` — editor settings (skip for neovim users; the bind-mounted `~/.config/nvim/` is the configuration source)

For Compose-based projects (DemoStand-shaped), DevPod supports `dockerComposeFile` + `service` in `.devcontainer.json`; sidecars (Postgres, etc.) start alongside the dev container. See upstream DevPod docs for the exact schema.

**Precondition before `devpod up`:** the host must have run `make symlinks-fedora`. Bind-mount sources must exist as files, not as missing paths — Docker silently creates an empty directory at the target when a source is missing, breaking shell startup. `utils/install-personal-tools devpod` checks this and fails loudly if it happens, but stowing first is the real fix.

## Port routing — no host port collisions across projects

Multiple projects each spin up their own Postgres on 5432, their own dev server on 3000, etc. With DevPod's default `forwardPorts` (binds to `127.0.0.1`) the second project to launch fails with `address already in use`. The dotfiles workflow solves this by giving each project a private loopback IP and publishing the container's ports on that IP only.

### Mechanism

1. `utils/devpod-allocate-loopback-ip <project>` reads `/etc/hosts`, returns the already-registered IP for `<project>` if present, otherwise sudo-appends a new entry on the first free `127.0.0.X`:

   ```
   # devpod-loopback: fenix=127.0.0.2
   127.0.0.2	fenix
   ```

2. `utils/devpod-up` is a thin wrapper that derives the project name from `$(basename $PWD)`, runs the allocator, exports `LOOPBACK_IP=…`, and execs `devpod up`. Alias it as `dpup` (or symlink into `~/.local/bin`) and use it instead of bare `devpod up`.

3. The project's `.devcontainer.json` publishes ports on the env-substituted IP:

   ```jsonc
   "runArgs": [
     "--publish=${localEnv:LOOPBACK_IP}:3000:3000",
     "--publish=${localEnv:LOOPBACK_IP}:5432:5432"
     // … one line per port the project exposes
   ]
   ```

   Inside the container, services bind to plain `0.0.0.0` on standard ports — no per-project port re-mapping required.

### Result

```
http://fenix:3000      → 127.0.0.2:3000   → fenix container :3000
http://fenix:5432      → 127.0.0.2:5432   → fenix container :5432
http://demostand:3000  → 127.0.0.3:3000   → demostand container :3000
```

No collisions, no project-aware port numbering, and browser/Postman/curl targets are stable across reboots and rebuilds.

### Platform notes

- **Linux**: `127.0.0.0/8` is fully routed to `lo` by default — no `ifconfig alias` needed. The allocator just appends to `/etc/hosts` and you're done.
- **macOS**: each extra loopback IP needs `sudo ifconfig lo0 alias 127.0.0.X up` before docker can publish to it. The dotfiles workflow assumes macOS users stay on devenv (no per-project containers); the allocator does not attempt `lo0` aliasing. If you do run dev containers on macOS, write a small launchd plist or run the alias commands manually.
- **Cleanup**: removing a project means manually deleting both lines (`# devpod-loopback: …` marker + the hosts entry) from `/etc/hosts`. The allocator does not garbage-collect.

### Trade-offs

- VS Code / DevPod auto-list of forwarded ports goes away (those read `forwardPorts`, not `runArgs`). Neovim users don't care; VS Code users keep `forwardPorts` and pay the collision cost, or live without the list.
- `${localEnv:LOOPBACK_IP}` is unset if the user runs `devpod up` directly (bypassing the wrapper). DevPod will then publish to an empty-string IP and docker errors out — preferable to silently binding to `0.0.0.0`. Treat the wrapper as mandatory.

## Pre-commit inside the container

Per-project `.pre-commit-config.yaml` is owned by whichever environment generates it. The macOS+devenv flow uses devenv's autogenerated version (a symlink into `/nix/store`, gitignored). The container flow ships its own static `.pre-commit-config.container.yaml` (checked in) with the same hook list rewritten to `entry:` lines that resolve via PATH (mise-provided binaries). The two coexist because `.git/hooks/pre-commit` is per-machine and each environment installs its own.

Container bootstrap chains `pre-commit install -c .pre-commit-config.container.yaml` after `install-personal-tools devpod`, persisting the config path into the generated hook so subsequent `git commit` invocations from the container pick up the container hooks automatically.

The container config's first hook refuses commits made from outside the container (checks for `/.dockerenv` / `/run/.containerenv`). `--no-verify` is the documented escape hatch. See `~/projects/ablt/fenix/.pre-commit-config.container.yaml` for a worked example.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `install-personal-tools: /home/<user>/.bashrc is a directory` (or `.zshrc` / `.zshenv` — any of the three) | Host hasn't stowed; Docker created empty dir at mount target | Run `make symlinks-fedora` on host, recreate container |
| First `nvim` hangs 15–60s | Lazy bootstrap + treesitter compile inside container | Wait it out; subsequent launches are fast |
| `git push` prompts for password | DevPod SSH agent not forwarded | Verify `eval $(ssh-agent)` + `ssh-add` on host; check DevPod ssh-config |
| Files owned by wrong UID/GID inside container | Host UID ≠ container user UID | Set `remoteUser` in `.devcontainer.json` to match the host user; verify with `id` inside the container. |
| `mise install` finds no tools | Project lacks `.mise.toml`; global config is empty by design | Add `.mise.toml` to project root with the tool versions you need |
| `docker: Error response from daemon: invalid containerPort: :3000` on `devpod up` | `LOOPBACK_IP` unset — `devpod up` was called directly, bypassing the `devpod-up` wrapper | Use `devpod-up` (or set `LOOPBACK_IP` manually) so `${localEnv:LOOPBACK_IP}` resolves |
| `pre-commit` hook fails with "commit from inside the dev container only" | You ran `git commit` from the host on a project whose container config installed the container-only guard | Commit from inside the container, or `git commit --no-verify` to bypass (use sparingly) |

For deeper logs: `journalctl --user -n 50` on host for DevPod issues; `devpod logs <project>` for container build/run logs.
