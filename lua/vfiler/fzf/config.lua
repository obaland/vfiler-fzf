local core = require 'vfiler/core'
local sink = require 'vfiler/fzf/sink'

local M = {}

M.configs = {
  action = {
    ['ctrl-t'] = 'tab split',
  },

  options = {
    '--layout=reverse',
  },

  layout = {
    window = {
      width = 0.9,
      height = 0.6,
    },
  },

  sink = sink.open_by_choose,
}

function M.setup(configs)
  return core.table.merge(M.configs, configs)
end

return M
