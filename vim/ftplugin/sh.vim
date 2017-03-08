setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

nnoremap <buffer> <C-CR> :call <SID>Eval('n')<CR>
"inoremap <buffer> <C-CR> <ESC>:call <SID>Eval('i')<CR>a
inoremap <buffer> <C-CR> <ESC>:call <SID>Eval('i')<CR>
vnoremap <buffer> <C-CR> :call <SID>EvalVisual()<CR>

let g:EvalCommand = ""
function! s:Eval(mode)
    let s:saved_reg = @"
    if a:mode == 'v'
        silent normal `<v`>
        silent normal y
        let @" = substitute(@", '\\\n', '', 'g')
        let @" = substitute(@", '\n', ';', 'g')
    else
        silent normal yy
    endif
    let @" = substitute(@", '[%#!]', '\\\0', 'g')
    execute '!' . g:EvalCommand . @"
    let @" = s:saved_reg
endfunction

function! s:EvalVisual() range
    call s:Eval('v')
endfunction
