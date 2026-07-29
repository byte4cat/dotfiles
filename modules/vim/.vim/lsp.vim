" Enable diagnostics highlighting
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)

let lspServers = [
    \ #{
    \    name: 'rust-analyzer',
    \    filetype: ['rust'],
    \    path: 'rust-analyzer',
    \    args: []
    \ },
    \ #{
    \    name: 'gopls',
    \    filetype: ['go', 'gomod'],
    \    path: 'gopls',
    \    args: []
    \ },
    \ #{
    \    name: 'pylsp',
    \    filetype: ['python'],
    \    path: 'pylsp',
    \    args: []
    \ },
    \ #{
    \    name: 'typescript-language-server',
    \    filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
    \    path: 'typescript-language-server',
    \    args: ['--stdio']
    \ }
    \ ]

autocmd User LspSetup call LspAddServer(lspServers)

" Key mappings
nnoremap gd :LspGotoDefinition<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap gl :LspDiag current<CR>
nnoremap <leader>nd :LspDiag next \| LspDiag current<CR>
nnoremap <leader>pd :LspDiag prev \| LspDiag current<CR>
inoremap <silent> <C-Space> <C-x><C-o>

" Set omnifunc for completion across supported filetypes
autocmd FileType rust,go,python,javascript,typescript,php setlocal omnifunc=lsp#complete

" Custom diagnostic sign characters
autocmd User LspSetup call LspOptionsSet(#{
    \    diagSignErrorText: '✘',
    \    diagSignWarningText: '▲',
    \    diagSignInfoText: '»',
    \    diagSignHintText: '⚑',
    \ })
