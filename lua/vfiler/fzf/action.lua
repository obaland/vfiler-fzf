local vim = require 'vfiler/vim'
local cmdline = require 'vfiler/cmdline'
local config = require 'vfiler/fzf/config'
local core = require 'vfiler/core'

local VFiler = require 'vfiler/vfiler'

local M = {}

local function fzf_options()
  local configs = config.configs
  local options = vim.to_vimdict({})
  options.options = ''

  -- Layout
  if configs.layout then
    for key, value in pairs(configs.layout) do
      if type(value) == 'table' then
        options[key] = vim.to_vimdict(value)
      else
        options[key] = value
      end
    end
  end

  -- Action
  if configs.action then
    local keys = {}
    for key, _ in pairs(configs.action) do
      -- skip default (enter) key
      if key ~= 'default' then
        table.insert(keys, key)
      end
    end
    if #keys > 0 then
      local expect = '--expect=' .. table.concat(keys, ',')
      options.options = options.options .. expect
    end
  end

  -- Fzf options
  if configs.options then
    local ops = table.concat(configs.options, ' ')
    options.options = options.options .. ' ' .. ops
  end

  return options
end

local function get_current_dirpath(vfiler)
  local item = vfiler.view:get_current()
  return item.isdirectory and item.path or item.parent.path
end

local function input_pattern()
  return cmdline.input('Pattern?')
end

------------------------------------------------------------------------------
-- Internal interfaces

function M._sink(key, condidate)
  for k, action in pairs(config.configs.action) do
    print(k, action)
  end

  local action = config.configs.action[key]
  if not action then
    core.message.error('No action has been set for "configs.action".')
    return
  end

  local path = core.path.normalize(condidate)
  if type(action) == 'string' then
    vim.command(action .. ' ' .. path)
  elseif type(action) == 'function' then
    local current = VFiler.get_current()
    action(current, path)
  else
    core.message.error('Action "%s" is no supported.', key)
  end
end

------------------------------------------------------------------------------
-- Actions
--

---  fzf Ag
function M.ag(vfiler)
  if vim.fn.executable('ag') == 0 then
    core.message.error('Not found "ag" command.')
    return
  end

  local pattern = input_pattern()
  if pattern == '' then
    return
  end
  local fzf_opts = fzf_options()
  local dirpath = get_current_dirpath(vfiler)
  vim.fn['vfiler#fzf#ag'](dirpath, fzf_opts)
end

---  fzf Grep
function M.grep(vfiler)
  if vim.fn.executable('grep') == 0 then
    core.message.error('Not found "grep" command.')
    return
  end

  local pattern = input_pattern()
  if pattern == '' then
    return
  end
  local fzf_opts = fzf_options()
  local dirpath = get_current_dirpath(vfiler)
  vim.fn['vfiler#fzf#grep'](dirpath, fzf_opts)
end

---  fzf Files
function M.files(vfiler)
  local fzf_opts = fzf_options()
  local dirpath = get_current_dirpath(vfiler)
  vim.fn['vfiler#fzf#files'](dirpath, fzf_opts)
end

---  fzf Rg
function M.rg(vfiler)
  if vim.fn.executable('rg') == 0 then
    core.message.error('Not found "rg" command.')
    return
  end

  local pattern = input_pattern()
  if pattern == '' then
    return
  end
  local fzf_opts = fzf_options()
  local dirpath = get_current_dirpath(vfiler)
  vim.fn['vfiler#fzf#rg'](dirpath, fzf_opts)
end

return M
