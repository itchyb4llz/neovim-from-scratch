return {
  {
    "laytan/cloak.nvim",
    opts = {
      enabled = true,
      cloak_character = "*",
      -- The applied highlight group (defaults to Comment)
      highlight_group = "Comment",
      patterns = {
        {
          -- Match file pattern (e.g., .env files)
          file_pattern = ".env*",
          -- Match key-value patterns inside the file
          cloak_pattern = "=.+",
        },
      },
    },
  },
}
