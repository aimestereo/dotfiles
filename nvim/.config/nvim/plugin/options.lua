local opt = vim.opt

-- Set highlight on search
opt.hlsearch = false
opt.incsearch = true

-- Make line numbers default
opt.number = true
opt.relativenumber = true

-- Enable mouse mode
-- opt.mouse = "a"
-- Disable mouse mode
opt.mouse = ""

-- Scroll padding (lines from cursor to top/bottom)
opt.scrolloff = 8

-- allow @ sing in file names
opt.isfname:append("@-@")

-- Wrapping
opt.wrap = true
opt.breakindent = true
opt.showbreak = " "
opt.linebreak = true
opt.breakindent = true

-- Auto indent new lines
opt.smartindent = true

-- Save undo history
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Case insensitive searching UNLESS /C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Decrease update time
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300

-- Appearance
vim.cmd.colorscheme("catppuccin")
opt.termguicolors = true
-- Columns
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.cursorline = true

-- Concealed text is completely hidden unless it's under the cursor.
opt.conceallevel = 2
