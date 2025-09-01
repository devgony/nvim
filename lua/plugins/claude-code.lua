return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      -- Terminal window settings
      window = {
        position = "float",
        float = {
          width = "90%", -- Take up 90% of the editor width
          height = "90%", -- Take up 90% of the editor height
          row = "center", -- Center vertically
          col = "center", -- Center horizontally
          relative = "editor",
          border = "double", -- Use double border style
        },
      },
      -- File refresh settings
      refresh = {
        enable = true, -- Enable file change detection
        updatetime = 100, -- updatetime when Claude Code is active (milliseconds)
        timer_interval = 1000, -- How often to check for file changes (milliseconds)
        show_notifications = true, -- Show notification when files are reloaded
      },
      -- Git project settings
      git = {
        use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
      },
      -- Shell-specific settings
      shell = {
        separator = "&&", -- Command separator used in shell commands
        pushd_cmd = "pushd", -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
        popd_cmd = "popd", -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
      },
      -- Command settings
      command = "claude", -- Command used to launch Claude Code
      -- Command variants
      command_variants = {
        -- Conversation management
        continue = "--continue", -- Resume the most recent conversation
        resume = "--resume", -- Display an interactive conversation picker

        -- Output options
        verbose = "--verbose", -- Enable verbose logging with full turn-by-turn output
      },
      -- Keymaps
      keymaps = {
        toggle = {
          normal = "<C-y>", -- Normal mode keymap for toggling Claude Code, false to disable
          terminal = "<C-y>", -- Terminal mode keymap for toggling Claude Code, false to disable
          variants = {
            continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
            verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
          },
        },
        window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
        scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
      },
    })
  end,
}
