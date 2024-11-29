local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local hide_without_apps = false
local query_workspaces = "aerospace list-workspaces --all"
local query_workspace_windows = "aerospace list-windows --json --workspace %s"

--
-- Get aerospace workspaces
--

function parse_string_to_table(s)
  local result = {}
  for line in s:gmatch("([^\n]+)") do
    table.insert(result, line)
  end
  return result
end

local file = io.popen(query_workspaces)
local result = file:read("*a")
file:close()

local workspaces = parse_string_to_table(result)

--
-- Utils
--

local function create_workspace(i, name)
  local space = Sbar.add("item", "space." .. i, {
    icon = {
      string = name,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = settings.group_paddings,
    padding_left = settings.group_paddings,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
  })

  return space
end

--
-- Get workspace windows
--

local function updateWindows(idx, name, space)
  local get_windows = string.format(query_workspace_windows, name)

  Sbar.exec(get_windows, function(open_windows)
    local icon_line = ""
    local no_app = true

    for i, open_window in ipairs(open_windows) do
      no_app = false
      local app_name = open_window["app-name"]
      local lookup = app_icons[app_name]
      local icon = ((lookup == nil) and app_icons["Default"] or lookup)
      icon_line = icon_line .. " " .. icon
    end

    if no_app then
      icon_line = " —"
    end

    Sbar.animate("tanh", 10, function()
      -- -- Hide from bar
      if no_app then
        if hide_without_apps then
          space:set({
            icon = { drawing = false },
            label = { drawing = false },
            background = { drawing = false },
            padding_right = 0,
            padding_left = 0,
          })
          return
        else
          space:set({
            icon = { drawing = true },
            label = {
              drawing = true,
              string = icon_line,
            },
            background = { drawing = true },
            padding_right = settings.group_paddings,
            padding_left = settings.group_paddings,
          })
          return
        end
      end

      space:set({
        icon = { drawing = true },
        label = {
          drawing = true,
          string = icon_line,
        },
        background = { drawing = true },
        padding_right = settings.group_paddings,
        padding_left = settings.group_paddings,
      })
    end)
  end)
end

--
-- Init
--

for idx, name in ipairs(workspaces) do
  local space = create_workspace(idx, name)

  space:subscribe("mouse.clicked", function(env)
    Sbar.exec("aerospace workspace " .. name)
  end)

  space:subscribe("aerospace_workspace_change", function(env)
    local selected = env.FOCUSED_WORKSPACE == name
    space:set({
      icon = { highlight = selected },
      label = { highlight = selected },
      background = { border_color = selected and colors.white or colors.bg2 },
    })
    updateWindows(idx, name, space)
  end)

  updateWindows(idx, name, space)
end

--
-- Support workspaces on/off
--

local spaces_switcher = Sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  },
})

spaces_switcher:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_switcher:query().icon.value == icons.switch.on
  spaces_switcher:set({
    icon = currently_on and icons.switch.off or icons.switch.on,
  })
end)

spaces_switcher:subscribe("mouse.entered", function(env)
  Sbar.animate("tanh", 30, function()
    spaces_switcher:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" },
    })
  end)
end)

spaces_switcher:subscribe("mouse.exited", function(env)
  Sbar.animate("tanh", 30, function()
    spaces_switcher:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0 },
    })
  end)
end)

spaces_switcher:subscribe("mouse.clicked", function(env)
  Sbar.trigger("swap_menus_and_spaces")
end)
