local vim = require 'vfiler/vim'
local config = require 'vfiler/fzf/config'
local core = require 'vfiler/core'

local VFiler = require 'vfiler/vfiler'

local M = {}

local function fzf_options()
  local configs = config.configs
  local options = vim.to_vimdict({})

  if configs.layout then
    for key, value in pairs(configs.layout) do
      options[key] = type(value) == 'table' and vim.to_vimdict(value) or value
    end
  end

  if configs.options then
    options.options = table.concat(configs.options, ' ')
  end

  if configs.action then
    local keys = {}
    for key, _ in pairs(configs.action) do
      table.insert(keys, key)
    end
    if #keys > 0 then
      local expect = ' --expect=' .. table.concat(keys, ',')
      options.options = options.options .. expect
    end
  end

  return options
end

function M.sink(condidate)
  local sink = config.configs.sink
  if not sink then
    core.message.error('No action has been set for "configs.sink".')
    return
  end
  local current = VFiler.get_current()
  print('sink:', condidate)
  sink(current, core.path.normalize(condidate))
end

function M.files(vfiler)
  local fzf_opts = fzf_options()
  local item = vfiler.view:get_current()
  fzf_opts.dir = item.isdirectory and item.path or item.parent.path
  vim.fn['vfiler_fzf#files'](fzf_opts)
end

return M
