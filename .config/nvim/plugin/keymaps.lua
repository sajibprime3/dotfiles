local set = vim.keymap.set
local k = vim.keycode

set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open File (e)xplorer." })
set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line." })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file." })
set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "No search highlight." })
set({ "n", "i" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Quick save." })
