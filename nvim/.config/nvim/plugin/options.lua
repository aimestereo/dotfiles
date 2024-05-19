-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"
-- Disable mouse mode
--vim.o.mouse = ''

-- Scroll padding (lines from cursor to top/bottom)
vim.o.scrolloff = 8

-- Columns
vim.o.signcolumn = "yes"
vim.wo.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- allow @ sing in file names
vim.opt.isfname:append("@-@")

-- Wrapping
vim.wo.wrap = true
vim.o.breakindent = true
vim.o.showbreak = " "
vim.wo.linebreak = true
vim.wo.breakindent = true

-- Auto indent new lines
vim.o.smartindent = true

-- Save undo history
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set colorscheme
--vim.cmd [[colorscheme onedark]]
vim.cmd.colorscheme("catppuccin")
-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Concealed text is completely hidden unless it's under the cursor.
vim.o.conceallevel = 2
