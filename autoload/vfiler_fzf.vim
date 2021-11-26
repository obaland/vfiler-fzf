"=============================================================================
" FILE: autoload/vfiler_fzf.vim
" AUTHOR: OBARA Taihei
" License: MIT license
"=============================================================================

function! vfiler_fzf#sink(condidate) abort
  call luaeval('require"vfiler/fzf/action".sink(_A)', a:condidate)
endfunction

function! vfiler_fzf#files(options) abort
  let a:options.sink = function('vfiler_fzf#sink')
  echom fzf#wrap('files', a:options)
  call fzf#run(fzf#wrap('files', a:options))
endfunction
