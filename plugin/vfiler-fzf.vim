if exists('g:loaded_vfiler_fzf')
  finish
endif

if has('nvim') && !has('nvim-0.5.0')
  echomsg 'vfiler-fzf requires Neovim 0.5.0 or later.'
  finish
elseif !has('nvim')
  if !has('lua') || v:version < 802
    echomsg 'vfiler-fzf requires Vim 8.2 or later with Lua support ("+lua").'
    finish
  endif
endif

let g:loaded_vfiler_fzf = 1
