local vim = require 'vfiler/vim'
local config = require 'vfiler/fzf/config'

local M = {}

function M.files(context, view)
  local item = view:get_current()
  local dir = item.isdirectory and item.path or item.parent.path

  local options = config.fzf_options()
  options.dir = dir

  vim.fn['vfiler_fzf#files'](options)
end

return M
