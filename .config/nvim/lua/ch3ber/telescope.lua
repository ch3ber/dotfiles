local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- telescope keymaps
keymap("n", "<leader>;f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>;l", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>;b", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>;o", "<cmd>Telescope oldfiles<cr>", opts)
keymap("n", "<leader>;z", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
keymap("n", "<leader>;h", "<cmd>Telescope help_tags<cr>", opts)

-- git keymaps
keymap("n", "<leader>;g", "<cmd>Telescope git_files<cr>", opts)
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts)
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts)
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts)
