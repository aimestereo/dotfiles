-- Theme pipeline integration.
--
-- Tracks the dotfiles `theme-set` system: every omarchy theme ships a
-- `~/.config/theme/themes/<name>/neovim.lua` describing its colorscheme plugin,
-- and `~/.config/theme/current` is a symlink to the active theme's rendered dir.
--
-- This module:
--   1. installs (lazy=true) every theme's colorscheme plugin, so a switch never
--      needs a clone;
--   2. applies the active theme at startup;
--   3. watches the `current` symlink and re-applies on retarget — no `theme-set`
--      coupling, nvim self-tracks.
--
-- It returns the union of install specs (consumed by lazy via `import = "plugins"`)
-- and performs its wiring as side effects at spec-collection time.

local theme_root = vim.fn.expand("~/.config/theme")
local themes_dir = theme_root .. "/themes"
local current_file = theme_root .. "/current/neovim.lua"

-- Quirks keyed by the raw `colorscheme` value found in a theme's
-- `{ "LazyVim/LazyVim", opts = { colorscheme = ... } }` entry. Anything not
-- listed here uses the plugin name from the spec and the raw colorscheme name.
local QUIRKS = {
  -- omarchy ships an invalid name; the real catppuccin scheme is "catppuccin".
  ["catppuccin-nvim"] = {
    scheme = "catppuccin",
    setup = function()
      require("catppuccin").setup({})
    end,
  },
  ["catppuccin-latte"] = {
    scheme = "catppuccin-latte",
    light = true,
    setup = function()
      require("catppuccin").setup({ flavour = "latte" })
    end,
  },
  -- rose-pine registers no "rose-pine-dawn" scheme; it reads vim.o.background.
  ["rose-pine-dawn"] = {
    scheme = "rose-pine",
    light = true,
  },
}

-- lazy.nvim plugin name: explicit `name`, else the repo path tail.
local function plugin_name(spec)
  return spec.name or spec[1]:match("([^/]+)$")
end

local function is_lazyvim(spec)
  return spec[1] == "LazyVim/LazyVim"
end

-- Build the install union: every theme's colorscheme plugin, deduped by lazy
-- name, reduced to a bare install spec (opts/config stripped — flavour and
-- per-theme overrides are applied dynamically at switch time).
local function build_specs()
  local seen, specs = {}, {}
  for name, kind in vim.fs.dir(themes_dir) do
    if kind == "directory" then
      local path = themes_dir .. "/" .. name .. "/neovim.lua"
      local ok, theme = pcall(dofile, path)
      if ok and type(theme) == "table" then
        for _, spec in ipairs(theme) do
          if type(spec) == "table" and type(spec[1]) == "string" and not is_lazyvim(spec) then
            local key = plugin_name(spec)
            if not seen[key] then
              seen[key] = true
              table.insert(specs, {
                spec[1],
                name = spec.name,
                branch = spec.branch,
                dependencies = spec.dependencies,
                lazy = true,
              })
            end
          end
        end
      end
    end
  end
  return specs
end

-- Track which config-fn themes have run their config this session, so re-applies
-- (e.g. aether.hotreload) don't re-register side effects every fs_event tick.
local configured = {}

local function apply()
  local ok, theme = pcall(dofile, current_file)
  if not ok or type(theme) ~= "table" then
    pcall(vim.cmd.colorscheme, "habamax")
    return
  end

  local raw_scheme, plugin_spec
  for _, spec in ipairs(theme) do
    if type(spec) == "table" then
      if is_lazyvim(spec) then
        raw_scheme = spec.opts and spec.opts.colorscheme
      elseif not plugin_spec and type(spec[1]) == "string" then
        plugin_spec = spec
      end
    end
  end

  if not plugin_spec or not raw_scheme then
    pcall(vim.cmd.colorscheme, "habamax")
    return
  end

  local quirk = QUIRKS[raw_scheme] or {}
  local scheme = quirk.scheme or raw_scheme
  local name = plugin_name(plugin_spec)

  vim.o.background = quirk.light and "light" or "dark"

  if not pcall(function()
    require("lazy").load({ plugins = { name } })
  end) then
    pcall(vim.cmd.colorscheme, "habamax")
    return
  end

  -- Themes carrying their own config (last-horizon/aether, ristretto/monokai-pro)
  -- set the colorscheme themselves and apply custom overrides. Run once per
  -- session; thereafter just re-issue the colorscheme.
  if type(plugin_spec.config) == "function" and not configured[name] then
    configured[name] = true
    if not pcall(plugin_spec.config, plugin_spec, plugin_spec.opts or {}) then
      pcall(vim.cmd.colorscheme, "habamax")
    end
    return
  end

  if quirk.setup then
    pcall(quirk.setup)
  end
  if not pcall(vim.cmd.colorscheme, scheme) then
    pcall(vim.cmd.colorscheme, "habamax")
  end
end

-- Transparency: applied on every ColorScheme event so it survives switches.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("ThemeTransparent", { clear = true }),
  callback = function()
    if not vim.g.theme_transparent then
      return
    end
    for _, group in ipairs({
      "Normal",
      "NormalNC",
      "NormalFloat",
      "SignColumn",
      "FoldColumn",
      "EndOfBuffer",
    }) do
      vim.api.nvim_set_hl(0, group, { bg = "none" })
    end
  end,
})

-- Apply the active theme once plugins are available.
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.schedule(apply)
  end,
})

-- Watch the `current` symlink for retargets. We watch the parent directory and
-- filter on the entry name: watching the symlink path directly resolves to the
-- target inode and would miss a retarget.
local watcher = vim.loop.new_fs_event()
if watcher then
  watcher:start(theme_root, {}, function(err, filename)
    if not err and filename == "current" then
      vim.schedule(apply)
    end
  end)
end

return build_specs()
