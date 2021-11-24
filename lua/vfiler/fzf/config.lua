local core = require 'vfiler/core'
local vim = require 'vfiler/vim'

local M = {}

M.configs = {
  options = {
    '--layout=reverse',
  },

  layout = {
    window = {
      width = 0.9,
      height = 0.6,
    },
  },
}

function M.setup(configs)
  return core.table.merge(M.configs, configs)
end

function M.fzf_options()
  local options = vim.to_vimdict({})

  if M.configs.layout then
    for key, value in pairs(M.configs.layout) do
      options[key] = type(value) == 'table' and vim.to_vimdict(value) or value
    end
  end

  if M.configs.options then
    options.options = table.concat(M.configs.options, ' ')
  end
  return options
end

return M
