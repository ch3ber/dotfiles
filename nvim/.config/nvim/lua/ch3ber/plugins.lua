local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)

  -- +-----+
  -- | LSP |
  -- +-----+

  use "neovim/nvim-lspconfig"                         -- enable LSP
  use "williamboman/nvim-lsp-installer"               -- Simple to use language server installer

  -- +------------+
  -- | CUSTOM VIM |
  -- +------------+

  use "lunarvim/colorschemes"                         -- A bunch of colorschemes
  use "drewtempelmeyer/palenight.vim"                 -- Colorscheme
  use "folke/tokyonight.nvim"                         -- Colorscheme
  use {'kaicataldo/material.vim', branch = 'main' }   -- Colorscheme
  use "nvim-lualine/lualine.nvim"                     -- Status line
  use "akinsho/nvim-bufferline.lua"                   -- Buffer line

  -- +--------------+
  -- | CODE SUPPORT |
  -- +--------------+

  use {'neoclide/coc.nvim', branch = 'release'}  -- Auto completion for code
  use "norcalli/nvim-colorizer.lua"              -- Ver colores hexadecimales
  use "tpope/vim-surround"                       -- Cambiar parentesis correspondientes
  use "Yggdroot/indentLine"                      -- Show indentation with a line
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Code highlight
  use "numToStr/Comment.nvim"                       -- Easily comment stuff
  use 'JoosepAlviste/nvim-ts-context-commentstring' -- Comment JSX code

  -- +-------------------+
  -- | NVIM IMPROVEMENTS |
  -- +-------------------+

  use "wbthomason/packer.nvim"                   -- Have packer manage itself
  use "nvim-lua/popup.nvim"                      -- Telescope, multi herramienta de busqueda
  use "nvim-lua/plenary.nvim"                    -- Telescope, multi herramienta de busqueda
  use "nvim-telescope/telescope.nvim"            -- Telescope, multi herramienta de busqueda
  use "kyazdani42/nvim-web-devicons"             -- Icons used by many plugins
  use "tpope/vim-fugitive"                       -- Integracion con git
  use "mhinz/vim-signify"                        -- Show git diff in nvim
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  } -- File explorer

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

