return {
  "devgony/rein",
  dir = vim.fn.expand("~/OSC/devgony/rein"),
  lazy = true,
  cmd = "Rein",
  keys = {
    {
      "<M-r>",
      function()
        require("rein").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle rein UI",
    },
  },
  -- Use the mapping above in both modes, including inside rein's terminal.
  opts = { keymap = false },
}
