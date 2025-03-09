return {
  {
    "lifthrasiir/hangeul.vim",
    init = function()
      vim.cmd([[let hangeul_enabled = 0]])
    end,
    config = function()
      vim.keymap.set("i", "<C-h>", "<Plug>HanMode", { noremap = false, silent = true })
    end,
  },
}
