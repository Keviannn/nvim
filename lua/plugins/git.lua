return {
    'lewis6991/gitsigns.nvim',
    name = 'git',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('gitsigns').setup({
            current_line_blame = true,
            current_line_blame_opts = { delay = 700 },
            attach_to_untracked = true,

            signs = {
                add          = { text = '+' },
                change       = { text = '~' },
                delete       = { text = '⌄' },
                topdelete    = { text = '⌃' },
                changedelete = { text = 'b' },
                untracked    = { text = '|' },
            },
        })
    end,
}
