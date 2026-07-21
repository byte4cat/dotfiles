" FZF keymaps (requires Plug 'junegunn/fzf.vim')

" Files
nnoremap <leader>pf :Files<CR>
nnoremap <leader>ff :Buffers<CR>
nnoremap <leader>l :CList<CR>    " For quickfix list

" Grep current string
nnoremap <leader>fw :Rg <C-r><C-w><CR>

" Grep input string (fzf prompt)
nnoremap <leader>fs :Rg<Space>

" Grep for current file name (without extension)
nnoremap <leader>fc :execute 'Rg ' . expand('%:t:r')<CR>
