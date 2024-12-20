--------------------------------------------------------------------------------
-- Define Markdown Mode
--
-- Markdown Mode allows you to perform common Markdown-formatting tasks anywhere
-- that you're editing text. Use Control+m to turn on Markdown mode. Then, use
-- any shortcut below to perform a formatting action. For example, to format the
-- selected text as bold in Markdown, hit Control+m, and then b.
--
--   b => wrap the selected text in double asterisks ("b" for "bold")
--   c => wrap the selected text in backticks ("c" for "code")
--   i => wrap the selected text in single asterisks ("i" for "italic")
--   s => wrap the selected text in double tildes ("s" for "strikethrough")
--   l => convert the currently-selected text to an inline link, using a URL
--        from the clipboard ("l" for "link")
--------------------------------------------------------------------------------

local markdownMode = hs.hotkey.modal.new({}, "F20")

local This = {}

local msgStr = "Markdown Mode ( Hyper + m )"

local function wrapSelectedText(wrapCharacters)
  -- Preserve the current contents of the system clipboard
  local originalClipboardContents = hs.pasteboard.getContents()

  -- Copy the currently-selected text to the system clipboard
  keyUpDown("cmd", "c")

  -- Allow some time for the command+c keystroke to fire asynchronously before
  -- we try to read from the clipboard
  hs.timer.doAfter(0.2, function()
    -- Construct the formatted output and paste it over top of the
    -- currently-selected text
    local selectedText = hs.pasteboard.getContents()
    local wrappedText = wrapCharacters .. selectedText .. wrapCharacters
    hs.pasteboard.setContents(wrappedText)
    keyUpDown("cmd", "v")

    -- Allow some time for the command+v keystroke to fire asynchronously before
    -- we restore the original clipboard
    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(originalClipboardContents)
    end)
  end)
end

local function inlineLink()
  -- Fetch URL from the system clipboard
  local linkUrl = hs.pasteboard.getContents()

  -- Copy the currently-selected text to use as the link text
  keyUpDown("cmd", "c")

  -- Allow some time for the command+c keystroke to fire asynchronously before
  -- we try to read from the clipboard
  hs.timer.doAfter(0.2, function()
    -- Construct the formatted output and paste it over top of the
    -- currently-selected text
    local linkText = hs.pasteboard.getContents()
    local markdown = "[" .. linkText .. "](" .. linkUrl .. ")"
    hs.pasteboard.setContents(markdown)
    keyUpDown("cmd", "v")

    -- Allow some time for the command+v keystroke to fire asynchronously before
    -- we restore the original clipboard
    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(linkUrl)
    end)
  end)
end

local makeBold = function()
  wrapSelectedText("**")
end

local makeItalic = function()
  wrapSelectedText("*")
end

local makeStrikethrough = function()
  wrapSelectedText("~~")
end

local makeLink = function()
  inlineLink()
end

local makeCode = function()
  wrapSelectedText("`")
end

local mappings = {
  -- format: { {mods}, key, description, callback }
  { { "shift" }, "/", "toggle help" },
  { {}, "escape", "Cancel" },

  { {}, "b", "bold: double asterisks", makeBold },
  { {}, "c", "code: backticks", makeCode },
  { {}, "i", "italic: single asterisks", makeItalic },
  { {}, "s", "strikethrough: double tildes", makeStrikethrough },
  { {}, "l", "link: an inline link", makeLink },
}

-- Use Control+m to toggle Markdown Mode
hs.hotkey.bind({ "ctrl" }, "m", function()
  markdownMode:enter()
end)
markdownMode:bind({ "ctrl" }, "m", function()
  markdownMode:exit()
end)

--
-- Menu
--

local utils = require("keyboard.utils")

local function menuCallback(menuOption)
  --return true to close menu
  --example: hs.window.focusedWindow():upRight()
  -- local fw = hs.window.focusedWindow()
  -- fw[menuOption](fw)
  return true
end

local menu = utils.initMenu(markdownMode, msgStr, mappings, menuCallback)
This.toggle = menu.toggle
return This
