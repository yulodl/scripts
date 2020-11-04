colorscheme monokai
set t_Co=256  " vim-monokai now only support 256 colours in terminal.
set grepprg=/usr/bin/grep

let NERDTreeShowHidden=1
let g:NERDTreeWinPos="left"
let g:jsx_ext_required=0
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee\|build'

set nu
set colorcolumn=120

autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd Filetype java setlocal ts=2 sw=2 expandtab
autocmd Filetype php setlocal ts=2 sw=2 expandtab
autocmd Filetype json setlocal ts=2 sw=2 expandtab
autocmd FileType vue syntax sync fromstart
au BufRead,BufNewFile *.tpl set filetype=html

let g:syntastic_java_checkers=['javac']
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_javascript_checkers = ['eslint']
" let g:typescript_indent_disable = 1

map <leader>fr :call FEReviewers() <cr>
function! FEReviewers()
    " let feReviewers='xhgao, weisun, xinzhong, xymo, wenxiujiang, zhenkunliu, huayizhang, zhijiezhang, Amelia278, chenghengdu, hongweihu, Mengpeng, wangkai'
    let feReviewers='#WEB_REVIEWERS'
    let failed = append(line('.'), feReviewers)
endfunction
map <leader>br :call APIReviewers() <cr>
function! APIReviewers()
    let beReviewers='xhgao, wenxiujiang, guiyuanzhang, ylti, fanxin, SRCGT'
    let failed = append(line('.'), beReviewers)
endfunction
map <leader>fc :call FileComment(1) <cr>
function! FileComment(force)
    let ext = expand('%:e')
"    let fileName = substitute(expand('%:t'), '.' . ext, '', '')
    let fileName = expand('%:t')
    if a:force != 0 || (line("$") == 1 && getline(1) == '')
        if (ext == 'vue') 
            let fc = ['<!-- @author xiaodongyu -->']
            call add (fc, '<!-- @email xiaodongyu@yangqianguan.com -->')
            call add (fc, '<!-- @date ' . strftime("%Y-%m-%d %H:%M:%S") . ' -->')
            call add (fc, '<!-- @desc ' . fileName . ' -->')
            call add (fc, '')
        else
            " let fc = ['/**']
            " call add (fc, ' * @author xiaodongyu')
            " call add (fc, ' * @date ' . strftime("%Y/%-m/%-d-%p%-I:%M"))
            " call add (fc, ' * @file ' . fileName)
            " call add (fc, ' */')
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
endfunction
autocmd BufNewFile,BufReadPost *.js,*.ts,*.vue,*.scss call FileComment(0)
autocmd BufWritePre,FileWritePre *.js,*.ts,*.scss ks|call LastMod()|'s
function! LastMod()
  if line("$") > 20
    let l = 20
  else
    let l = line("$")
  endif
  exe "1," . l . "g/Last Modified by: /s/Last Modified by: .*/Last Modified by: xiaodongyu"
  exe "1," . l . "g/Last Modified time: /s/Last Modified time: .*/Last Modified time: " .
  \ strftime("%Y-%m-%d %H:%M:%S")
endfunction
function! SetlineAndCursor(lnum, content, cursorLnum, cursorCnum) 
    let failed = setline(a:lnum, a:content)
    let cursorLnum = a:cursorLnum ? a:cursorLnum : a:lnum
    let cursorCnum = a:cursorCnum ? a:cursorCnum : len(a:content) 
    call cursor(cursorLnum, cursorCnum)
endfunction
map <leader>fm :call SetlineAndCursor(1, '[OA FE] ', '', '') <cr>
map <leader>ao :call SetlineAndCursor(1, '[yqd_web_admin][海外后台] ', '', '') <cr>
map <leader>vc :call SetlineAndCursor(1, '[vue-spa][海外催收] ', '', '') <cr>
map <leader>va :call SetlineAndCursor(1, '[vue-spa][海外后台] ', '', '') <cr>
map <leader>bm :call SetlineAndCursor(1, '[yqg_oa] ', '', '') <cr>
let g:lightline = {
\     'inactive': {
\       'left': [ [ 'relativepath' ] ]
\     },
\ }
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
        let failed = setline('.', curLine . ' />')
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

map <leader>r :! find . -type f -name '*.js' -exec sed -i '' -e $'s///g' {} +
" :! find . -type f -name '*.js' -exec sed -i '' -e $'s/@babel\/polyfill/core-js\/stable\';\\\nimport \'regenerator-runtime\/runtime/g' {} +
" map <leader>d :execute "!node " . expand("%p") <cr>
map <leader>d :execute "!cat " . expand("%:p") . " \| node --input-type=module" <cr>
