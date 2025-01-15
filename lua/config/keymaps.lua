-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

map("n", "<c-t>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
map("t", "<C-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- map({ "n", "i", "v" }, "<M-j>", "<nop>", { desc = "Disable <M-j>" })
-- map({ "n", "i", "v" }, "<M-k>", "<nop>", { desc = "Disable <M-k>" })
--
-- map({ "n", "i", "v" }, "<M-p>", "<nop>", { desc = "Disable <M-p>" })
-- map({ "n", "i", "v" }, "<M-n>", "<nop>", { desc = "Disable <M-n>" })

local function safe_del_keymap(mode, lhs)
  if vim.fn.maparg(lhs, mode) ~= "" then
    vim.api.nvim_del_keymap(mode, lhs)
  end
end

safe_del_keymap("n", "<M-j>")
safe_del_keymap("i", "<M-j>")
safe_del_keymap("v", "<M-j>")

safe_del_keymap("n", "<M-k>")
safe_del_keymap("i", "<M-k>")
safe_del_keymap("v", "<M-k>")

safe_del_keymap("n", "<M-p>")
safe_del_keymap("i", "<M-p>")
safe_del_keymap("v", "<M-p>")

safe_del_keymap("n", "<M-n>")
safe_del_keymap("i", "<M-n>")
safe_del_keymap("v", "<M-n>")

safe_del_keymap("n", "s")
safe_del_keymap("x", "s")

map({ "v" }, "J", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map({ "v" }, "K", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- map({ "i" }, "jk", "<esc>", { desc = "enter normal mode" })
map({ "i" }, "jj", "<esc>", { desc = "enter normal mode" })
-- map({ "i" }, "<esc>", "<esc>", { normap = true, desc = "enter normal mode" })
