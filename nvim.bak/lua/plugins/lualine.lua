return {
	"nvim-lualine/lualine.nvim",
	jdependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "dracula",
			},
			{
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						"filename",
						{
							"require'sf'.get_target_org()",
							-- cond = function()
							--   return vim.bo.filetype == 'apex'
							-- end
						},
					},
					lualine_x = { "encoding", "filetype" },
					-- lualine_x = {'encoding', 'fileformat', 'filetype'},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			},
		})
	end,
}
