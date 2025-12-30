require("telescope").setup({
  defaults = {
    file_ignore_petterns = { "dune.lock" },
  },
  extensions = {
    wrap_results = true,
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case",
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")

-- stylua: ignore
vim.keymap.set("n", "<leader>f", "", { desc = "Find" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "(f)ind (f)iles." })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep." })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Nvim Help." })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers." })
vim.keymap.set("n", "<leader>f/", builtin.current_buffer_fuzzy_find, { desc = "Find In file." })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>h", "", { desc = "Get helps from CodeHelp." })
vim.keymap.set("n", "<leader>hf", function()
  builtin.find_files({ cwd = vim.fn.expand("$HOME/codeHelp") })
end, { desc = "Find Code help." })
vim.keymap.set("n", "<leader>hg", function()
  builtin.live_grep({ cwd = vim.fn.expand("$HOME/codeHelp") })
end, { desc = "Live grep Code help." })
