require("fzf-lua").setup {
	files = {
		find_opts         = [[-type f \! -path '*/.git/*' \! -path '*/.jj/*']],
		rg_opts           = [[--color=never --files -g "!.git" -g "!.jj"]],
		fd_opts           = [[--color=never --type f --type l --exclude .git --exclude .jj --exclude Doxygen]],
	}
}
