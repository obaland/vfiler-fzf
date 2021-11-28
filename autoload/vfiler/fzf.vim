"=============================================================================
" FILE: autoload/vfiler/fzf.vim
" AUTHOR: OBARA Taihei
" License: MIT license
"=============================================================================

function! vfiler#fzf#sink(condidate) abort
  let l:key = get(w:, 'vfiler_fzf_key', '')
  if l:key == ''
    if strlen(a:condidate) > 0
      let w:vfiler_fzf_key = a:condidate
    else
      " press enter key
      let w:vfiler_fzf_key = 'default'
    endif
    return
  endif
  call luaeval(
        \ 'require"vfiler/fzf/action"._sink(_A.key, _A.condidate)',
        \ {'key': l:key, 'condidate': a:condidate}
        \ )
endfunction

function! vfiler#fzf#ag(dirpath, options) abort
  let a:options.dir = a:dirpath
  let a:options.sink = function('vfiler#fzf#sink')
  call fzf#vim#ag('', fzf#vim#with_preview(a:options), 0)
endfunction

let s:grep_options = [
      \ '--recursive',
      \ '--ignore-case',
      \ '--line-number',
      \ ]
let s:grep_options_string = join(s:grep_options, ' ')

function! vfiler#fzf#grep(dirpath, options) abort
  let a:options.dir = a:dirpath
  let a:options.sink = function('vfiler#fzf#sink')
  let l:command = 'grep ' . s:grep_options_string
  call fzf#vim#grep(l:command, 1, fzf#vim#with_preview(a:options), 0)
endfunction

function! vfiler#fzf#files(dirpath, options) abort
  let a:options.sink = function('vfiler#fzf#sink')
  call fzf#vim#files(a:dirpath, fzf#vim#with_preview(a:options), 0)
endfunction

let s:rg_options = [
      \ '--column',
      \ '--line-number',
      \ '--no-heading',
      \ '--color=always',
      \ '--smart-case',
      \ ]
let s:rg_options_string = join(s:rg_options, ' ')

function! vfiler#fzf#rg(dirpath, options) abort
  let a:options.dir = a:dirpath
  let a:options.sink = function('vfiler#fzf#sink')
  let l:command = 'rg ' . s:rg_options_string . ' -- ""'
  call fzf#vim#grep(l:command, 1, fzf#vim#with_preview(a:options), 0)
endfunction
