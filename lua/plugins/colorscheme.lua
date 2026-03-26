return {
  { "lunarvim/darkplus.nvim", priority = 1000 },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      transparent_mode = true,
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "auto", -- auto, main, moon, or dawn
      dark_variant = "main",
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
    },
  },
}
