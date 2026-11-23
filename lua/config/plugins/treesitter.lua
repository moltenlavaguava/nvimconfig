return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({ "rust", "lua", "vim", "vimdoc" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rust", "lua", "vim", "help" },
        callback = function()
          -- highlighting
          vim.treesitter.start()

          -- folding (Neovim built-in)
          -- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          -- vim.wo[0][0].foldmethod = "expr"

          -- indentation (experimental, from the plugin)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
