vim.cmd "let g:netrw_keepdir = 0"   			 -- fix bug move directory with vim Explorer
vim.opt.autoindent = true   							 -- habilitar autoidentacion
vim.opt.clipboard = "unnamedplus"          -- allows neovim to access the system clipboard
vim.opt.cursorcolumn = true                -- colorear la columna dode esta le cursor
vim.opt.cursorline = true                  -- colorear la linea donde esta el cursor
vim.opt.fileencoding = "utf-8"             -- the encoding written to a file
vim.opt.hlsearch = true                    -- highlight all matches on previous search pattern
vim.opt.expandtab = true                   -- convert tabs to spaces
vim.opt.shiftwidth = 2                     -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                        -- insert 2 spaces for a tab
vim.opt.hidden = true                      -- cambiar entre buffers sin guardar
vim.opt.ignorecase = true                  -- ignore case in search patterns
vim.opt.mouse = "a"                        -- allow the mouse to be used in neovim
vim.opt.showtabline = 2                    -- always show tabs
vim.opt.showmode = false                   -- we don't need to see things like -- INSERT -- anymore
vim.opt.wrap = false                       -- display lines as one long line
vim.opt.number = true                      -- set numbered lines
vim.opt.relativenumber = true              -- set relative numbered lines
vim.opt.numberwidth = 4                    -- set number column width to 2 {default 4}
vim.opt.ruler = true                       -- activar la regla
vim.opt.scrolloff = 3                 		 -- scrollear 3 lineas antes
vim.opt.showmatch = true                   -- mostrar parentesis correspondiente
vim.opt.signcolumn = "yes"                 -- always show the sign column on the left side, otherwise it would shift the text each time
--vim.opt.smartindent = true                 -- habilitar autoidentacion
vim.opt.termguicolors = true               -- habilitar colores perzonalidados
vim.opt.syntax = "on"                      -- mostrar la sintaxis de archivos
vim.opt.cmdheight = 2                      -- more space in the neovim command line for displaying messages
vim.opt.backup = false                     -- creates a backup file
vim.opt.conceallevel = 0                   -- so that `` is visible in markdown files
vim.opt.timeoutlen = 1000                  -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                    -- enable persistent undo
vim.opt.updatetime = 300                   -- faster completion (4000ms default)
vim.opt.guifont = "Hack Regular Nerd Font Complete Mono"    -- the font used in graphical neovim applications