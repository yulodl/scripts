" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Tools
" A tree explorer plugin for vim.
Plug 'scrooloose/nerdtree'
" Nodejs extension host for vim & neovim, load extensions like VSCode and host language servers.
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
" Plug 'dense-analysis/ale'
" Open file under cursor when pressing gf
Plug 'yulodl/open_file_under_cursor.vim'
" A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'
" A Vim plugin which shows git diff markers in the sign column and stages/previews/undoes hunks and partial hunks.
Plug 'airblade/vim-gitgutter'
" insert or delete brackets, parens, quotes in pair
Plug 'jiangmiao/auto-pairs'
" Fuzzy file, buffer, mru, tag, etc finder.
Plug 'ctrlpvim/ctrlp.vim'
" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'
" 🌷 Distraction-free writing in Vim
Plug 'junegunn/goyo.vim'
" vim-snipmate default snippets
Plug 'honza/vim-snippets'
" Generate JSDoc to your JavaScript code.
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'javascript.jsx','typescript'],
  \ 'do': 'make install'
\}
" Vim plugin for intensely nerdy commenting powers
Plug 'preservim/nerdcommenter'
" 🏋️ Display the import size of the JavaScript packages in Vim!
Plug 'yardnsm/vim-import-cost', { 'do': 'npm install' }
" 🔦 [Vim script] JSX and TSX syntax pretty highlighting for vim.
Plug 'MaxMEllon/vim-jsx-pretty'

" Syntax
" A solid language pack for Vim.
Plug 'sheerun/vim-polyglot'

" ColorSchemas
" Refined Monokai color scheme for vim, inspired by Sublime Text
Plug 'crusoexia/vim-monokai'
" A dark Vim/Neovim color scheme inspired by Atom's One Dark syntax theme.
Plug 'joshdick/onedark.vim'

" Initialize plugin system
call plug#end()

" airblade/vim-gitgutter
let g:gitgutter_terminal_reports_focus=0
let g:gitgutter_enabled=1

" old pathogen vimrc
source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

" heavenshell/vim-jsdoc
nmap <silent> <C-l> ?function<cr>:noh<cr><Plug>(jsdoc)

" preservim/nerdcommenter for vue ref: https://github.com/posva/vim-vue#nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction

" overwirte pathogen vimrc
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" ref: https://github.com/neoclide/coc.nvim
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>ft  <Plug>(coc-format-selected)
nmap <leader>ft  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" ref: https://github.com/neoclide/coc-snippets
" Use <C-l> for trigger snippet expand.
" imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)
noremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" old pathogen my_configs
syntax on
if ($COLORTERM == 'truecolor')
    set termguicolors
else
    set t_Co=256
endif
 colorscheme monokai
" colorscheme onedark
set grepprg=/usr/bin/grep

let NERDTreeShowHidden=1
let g:NERDTreeWinPos="left"
let g:jsx_ext_required=0
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee\|build'

set nu
set colorcolumn=120

autocmd Filetype json setlocal ts=2 sw=2 expandtab
" json support C-style line comment (//) for neoclide/coc.nvim configfile
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType vue syntax sync fromstart
au BufRead,BufNewFile *.tpl set filetype=html

map <leader>fr :call FEReviewers() <cr>
function! FEReviewers()
    let feReviewers='#WEB_REVIEWERS'
    let failed = append(line('.'), feReviewers)
endfunction
map <leader>fc :call FileComment(1) <cr>
function! FileComment(force)
    let ext = expand('%:e')
    let fileName = substitute(expand('%:t'), '.' . ext, '', '')
     if (line("$") == 1 && getline(1) == '') || a:force
        if (ext == 'vue') 
            let fc = ['<!-- @author xiaodongyu -->']
            call add (fc, '<!-- @email xiaodongyu@yangqianguan.com -->')
            call add (fc, '<!-- @date ' . strftime("%Y-%-m-%-d %H:%M:%S") . ' -->')
            call add (fc, '<!-- @desc ' . fileName . '.vue -->')
            call add (fc, '')
        else
            let time = strftime("%Y-%m-%d %H:%M:%S")
            let fc = ['/*']
            call add (fc, ' * @Author: xiaodongyu')
            call add (fc, ' * @Date ' . time)
            call add (fc, ' * @Last Modified by: xiaodongyu')
            call add (fc, ' * @Last Modified time: ' . time)
            call add (fc, ' */')
        endif
        let failed = append(0, fc)
     endif
endfunction
map <leader>fj :call FormatJson() <cr>
function! FormatJson()
    let tmp = '/tmp/vim-json.js'
    let path = expand("%p")
    execute "!echo 'module.exports=' > ". tmp ." && cat " . path .  " >> ". tmp . " && node -p \"JSON.stringify(require('". tmp ."'), null, 2)\" > " . path
    "let content = substitute(join(getline(1, '$'), ''), "\"", "'", "g")
    "echo content
    "execute "!/usr/local/bin/node -p \"JSON.stringify(" . content . ", null, 2)\" > " . expand("%:p")
endfunction
autocmd BufNewFile,BufReadPost *.js,*.ts,*.vue,*.scss call FileComment(0)
autocmd BufWritePre,FileWritePre *.js,*.ts,*.scss ks|call LastMod()|'s
function! LastMod()
  if line("$") > 20
    let l = 20
  else
    let l = line("$")
  endif
  silent exe "1," . l . "g/Last Modified by: /s/Last Modified by: .*/Last Modified by: xiaodongyu"
  silent exe "1," . l . "g/Last Modified time: /s/Last Modified time: .*/Last Modified time: " .
  \ strftime("%Y-%m-%d %H:%M:%S")
endfunction
function! SetlineAndCursor(lnum, content, cursorLnum, cursorCnum) 
    let failed = setline(a:lnum, a:content)
    let cursorLnum = a:cursorLnum ? a:cursorLnum : a:lnum
    let cursorCnum = a:cursorCnum ? a:cursorCnum : len(a:content) 
    call cursor(cursorLnum, cursorCnum)
endfunction
map <leader>fm :call SetlineAndCursor(1, '[OA FE] ', '', '') <cr>
map <leader>oa :call SetlineAndCursor(1, '[vue-spa][海外后台] ', '', '') <cr>
map <leader>oc :call SetlineAndCursor(1, '[vue-spa][海外催收] ', '', '') <cr>
map <leader>oe :call SetlineAndCursor(1, '[vue-spa][ec-call] ', '', '') <cr>
map <leader>ca :ClearAllCtrlPCaches <cr>

let g:goyo_width=126
function! s:goyo_enter()
    set nu
    let b:quitting = 0
    let b:quitting_bang = 0
    autocmd QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
    " Quit Vim if this is the only remaining buffer
    if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
            qa!
        else
            qa
        endif
    endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

map <leader>t :call ExpandTag("single") <cr>
map <leader>tt :call ExpandTag("pair") <cr>
function! ExpandTag(mode)
    let curword = expand("<cWORD>")
    if (strlen(curword) == 0)
        return
    endif
    let curLine = getline('.')
    let idx = stridx(curLine, curword)
    let curLine = substitute(curLine, curword, '<' . curword, '')
    if (a:mode == "single")
        let failed = setline('.', curLine . '/>')
    else
        let failed = setline('.', curLine . '>')
        let failed = append(".", repeat(' ', idx) . '</' . curword . '>')
    endif
endfunction
" map java enum to js object
map <leader>mj :%s/^\s*\([A-Z_]*\).*"\(\W\+\)"[,)][^,]*/\1: '\2'/g <cr>
" map java enum to json object
map <leader>mjj :%s/^\s*\([A-Z_]*\).*"\(\W\+\)"[,)][^,]*/"\1": "\2"/g <cr>
map <F4> :execute "vimgrep /" . expand("<cword>") . "/j common/**" <Bar> cw<CR>

map <leader>ve :vne <bar> :e. <cr>
map <leader>se :new <bar> :e. <cr>
map <leader>q :q <cr>
map <leader>qa :qa <cr>

map <leader>r :! find . -type f -exec sed -i '' s///g {} +
" map <leader>d :execute "!node " .expand("%:p") <cr>
" map <leader>d :execute "!cat " .expand("%:p") . " \| node --input-type=module" <cr>
map <leader>d :call ExecuteCode() <cr>
function! ExecuteCode()
    let fullName = expand('%:p')
    let ext = expand('%:e')
    if (ext =~ 'm\?js$')
        execute "!cat " . fullName . " \| node --input-type=module"
    elseif (ext == 'cpp')
        let outName = expand('%:p:r') . ".out"
        execute "!g++ " . fullName . " -o " . outName . " && " . outName
    elseif (ext == 'java')
        let className = expand('%:r')
        execute "!javac " . fullName . " && java " . className
    endif
endfunction
