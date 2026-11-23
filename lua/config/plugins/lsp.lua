return {
    {
	"neovim/nvim-lspconfig",
	config = function()
	    -- customize settings
	    vim.lsp.config("lua_ls", {
		settings = {
		    Lua = {
			runtime = { version = "LuaJIT" },
		    },
		},
	    })

	    vim.lsp.enable("lua_ls")
	end,
    },
}
