# vfiler-fzf
fzf :heart: vfiler.vim

## Instalattion

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'obaland/vfiler.vim'
Plug 'obaland/vfiler-fzf'
```

After installation, specify the action for any mapping in vfiler.vim.
```lua
local fzf_action = require'vfiler/fzf/action'
require'vfiler/config'.setup {
  mappings = {
    ['f'] = fzf_action.files
  },
}
```

## Support actionsn
- files
- grep
- ag
- rg
