-- ~/.config/nvim/lua/plugins/hyprls.lua

return {
  -- 1) LSP-oppsett for hyprls
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.hyprls = {
        cmd = { "hyprls" }, -- må ligge i PATH
        filetypes = { "hyprlang" },
      }
    end,
  },

  -- 2) Treesitter-parser for Hyprland
  {
    "luckasRanarison/tree-sitter-hyprlang",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- 3) Be nvim-treesitter om å installere "hyprlang" også
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        table.insert(opts.ensure_installed, "hyprlang")
      end
    end,
  },
}
