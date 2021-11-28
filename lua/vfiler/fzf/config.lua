local core = require 'vfiler/core'
local sink = require 'vfiler/fzf/sink'

local M = {}

M.configs = {
  action = {
    default = sink.open,
    ['ctrl-t'] = 'tab split',
    ['ctrl-x'] = 'split',
    ['ctrl-v'] = 'vsplit',
  },

  options = {},
  layout = {},
}

function M.setup(configs)
  return core.table.merge(M.configs, configs)
end

return M
