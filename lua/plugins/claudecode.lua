return {
  "coder/claudecode.nvim",
  lazy = false,
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = { provider = "none" },
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
