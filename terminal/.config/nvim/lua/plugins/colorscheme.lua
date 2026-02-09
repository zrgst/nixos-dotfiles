return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- Her kan du også velge frappe, macchiato eller latte
      transparent_background = false, -- Siden du liker at terminalbakgrunnen skinner igjennom
      integrations = {
        telescope = true,
        neotree = true,
        treesitter = true,
        notify = true,
        mini = true,
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
