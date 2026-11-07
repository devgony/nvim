-- Keep shell tabs separate from LazyVim's count-based terminals and the omp terminal.
local shell_tabs = {}
local current_tab = 1
local tab_count = 5
local shifted_digits = { "!", "@", "#", "$", "%" }

local border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
local function colored_border(group)
  local border = {}
  for index, char in ipairs(border_chars) do
    border[index] = { char, group }
  end
  return border
end
local shell_border = colored_border("SnacksShellBorder")
local omp_border = colored_border("SnacksOmpBorder")

local function highlight_terminal_borders()
  vim.api.nvim_set_hl(0, "SnacksShellBorder", { fg = "#bb9af7" })
  vim.api.nvim_set_hl(0, "SnacksOmpBorder", { fg = "#7aa2f7" })
end
highlight_terminal_borders()
vim.api.nvim_create_autocmd("ColorScheme", { callback = highlight_terminal_borders })

-- Snacks closes floating windows when hiding them; switching focus also needs to preserve their views.
local function save_terminal_view(terminal)
  if terminal:valid() then
    vim.b[terminal.buf].saved_terminal_view = vim.api.nvim_win_call(terminal.win, function()
      return {
        view = vim.fn.winsaveview(),
        insert = vim.fn.line("w$") == vim.api.nvim_buf_line_count(terminal.buf),
      }
    end)
  end
end

local function restore_terminal_view(terminal)
  local saved = vim.b[terminal.buf].saved_terminal_view
  if saved and not saved.insert and vim.api.nvim_get_mode().mode == "t" then
    vim.cmd.stopinsert()
  end
  if saved then
    vim.api.nvim_win_call(terminal.win, function()
      vim.fn.winrestview(saved.view)
    end)
  end
  -- Terminal mode follows the process cursor, so only resume it when the viewport was at the bottom.
  if (not saved or saved.insert) and vim.api.nvim_get_current_win() == terminal.win then
    vim.cmd.startinsert()
  end
end

local function track_terminal_focus(terminal)
  terminal:on("WinLeave", save_terminal_view, { buf = true })
  terminal:on("WinEnter", restore_terminal_view, { buf = true })
end

local function live_tab(index)
  local terminal = shell_tabs[index]
  return terminal and terminal:buf_valid() and not vim.b[terminal.buf].shell_tab_exited and terminal or nil
end

local function tab_bar(active)
  local tabs = {}
  for index = 1, tab_count do
    if live_tab(index) then
      tabs[#tabs + 1] = (index == active and "%#TabLineSel# [" or "%#TabLine#  ")
        .. index
        .. (index == active and "] " or "  ")
    end
  end
  return table.concat(tabs) .. "%#TabLineFill#"
end

local function refresh_bar()
  local terminal = shell_tabs[current_tab]
  if terminal and terminal:valid() then
    local text = tab_bar(current_tab)
    if terminal:valid() then
      terminal.opts.wo.winbar = text
      vim.wo[terminal.win].winbar = text
    end
  end
end

local function show_tab(index)
  local previous = shell_tabs[current_tab]
  if current_tab ~= index and previous and previous:valid() then
    previous:hide()
  end
  current_tab = index

  local terminal = live_tab(index)
  if not terminal then
    if shell_tabs[index] then
      shell_tabs[index]:close()
      shell_tabs[index] = nil
    end
    -- An explicit argv keeps the shell out of LazyVim's nil-command cache without a shell wrapper.
    terminal = Snacks.terminal.get(Snacks.terminal.parse(vim.o.shell), {
      count = index,
      start_insert = false,
      auto_insert = false,
      win = {
        position = "float",
        width = 0.98,
        height = 0.96,
        border = shell_border,
        wo = { winbar = tab_bar(index) },
        on_close = save_terminal_view,
        on_win = restore_terminal_view,
      },
    })
    shell_tabs[index] = terminal
    track_terminal_focus(terminal)
    vim.api.nvim_create_autocmd({ "TermClose", "BufWipeout" }, {
      buffer = terminal.buf,
      callback = function(event)
        if event.event == "TermClose" then
          vim.b[event.buf].shell_tab_exited = true
        end
        vim.schedule(refresh_bar)
      end,
    })
  end
  local text = tab_bar(index)
  if terminal ~= live_tab(index) then
    return show_tab(index)
  end
  terminal.opts.wo.winbar = text
  terminal:show():focus()
end

local function toggle_shell()
  local terminal = shell_tabs[current_tab]
  if terminal and terminal:valid() and vim.api.nvim_get_current_win() == terminal.win then
    terminal:hide()
  else
    show_tab(current_tab)
  end
end

local function adjacent_tab(direction)
  for offset = 1, tab_count do
    local index = ((current_tab - 1 + direction * offset) % tab_count) + 1
    if live_tab(index) then
      show_tab(index)
      return
    end
  end
  show_tab(current_tab)
end

local lazygit_opts = { count = 0, win = { position = "float", width = 0.98, height = 0.98 } }
local omp_opts = {
  count = 0,
  start_insert = false,
  auto_insert = false,
  win = {
    position = "float",
    width = 0.99,
    height = 0.99,
    border = omp_border,
    on_close = save_terminal_view,
    on_win = restore_terminal_view,
  },
}

local keys = {
  {
    "<M-t>",
    toggle_shell,
    mode = { "n", "t" },
    desc = "Toggle floating shell tab",
  },
  {
    "<M-H>",
    function()
      adjacent_tab(-1)
    end,
    mode = { "n", "t" },
    desc = "Previous shell tab",
  },
  {
    "<M-L>",
    function()
      adjacent_tab(1)
    end,
    mode = { "n", "t" },
    desc = "Next shell tab",
  },
  {
    "<M-o>",
    function()
      local terminal, created = Snacks.terminal.get({ "omp" }, omp_opts)
      if created then
        track_terminal_focus(terminal)
      else
        terminal:toggle()
      end
    end,
    mode = { "n", "t" },
    desc = "Toggle floating omp",
  },
  {
    "<M-g>",
    function()
      Snacks.lazygit(lazygit_opts)
    end,
    mode = { "n", "t" },
    desc = "Toggle floating lazygit",
  },
}

for index = 1, tab_count do
  for _, key in ipairs({ "<M-S-" .. index .. ">", "<M-" .. shifted_digits[index] .. ">" }) do
    keys[#keys + 1] = {
      key,
      function()
        show_tab(index)
      end,
      mode = { "n", "t" },
      desc = "Shell tab " .. index,
    }
  end
end

return {
  "folke/snacks.nvim",
  enabled = true,
  opts = {
    image = { enabled = false, formats = {} },
  },
  keys = keys,
}
