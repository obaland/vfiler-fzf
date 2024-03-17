local cmdline = require('vfiler/libs/cmdline')
local config = require('vfiler/fzf/config')
local core = require('vfiler/libs/core')
local vim = require('vfiler/libs/vim')

local VFiler = require('vfiler/vfiler')
local Context = require('vfiler/context')

local M = {}

local function fzf_options()
  local configs = config.configs
  local options = vim.dict({})
  options.options = ''

  -- Layout
  if configs.layout then
    for key, value in pairs(configs.layout) do
      if type(value) == 'table' then
        options[key] = vim.dict(value)
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

local function get_current_dirpath(view)
  local item = view:get_item()
  local path = item.isdirectory and item.path or item.parent.path
  local slash = '/'
  if core.is_windows and not vim.get_option('shellslash') then
    slash = '\\'
  end
  return path:gsub('[/\\]', slash)
end

local function execute(func, vfiler, view)
  local fzf_opts = fzf_options()
  local dirpath = get_current_dirpath(view)

  -- The vfiler's floating window automatically closes on buffer Leave.
  -- Therefore, there will be no window to return to after executing fzf,
  -- resulting in an error.
  -- To avoid this, delete the window before executing fzf.
  if view:type() == 'floating' then
    vfiler:wipeout()
  end

  vim.fn[func](dirpath, fzf_opts)
end

local function input_pattern()
  return cmdline.input('Pattern?')
end

local function new_dummy_vfiler(root_path)
  local ctx = Context.new(require('vfiler/config').configs)

  -- NOTE: Generate only the root, which affects subsequent processing.
  local fs = require('vfiler/libs/filesystem')
  local Directory = require('vfiler/items/directory')
  ctx.root = Directory.new(fs.stat(root_path))
  return VFiler.new(ctx)
end

------------------------------------------------------------------------------
-- Internal interfaces

function M._sink(key, condidate)
  local action = config.configs.action[key]
  if not action then
    core.message.error('No action has been set for "configs.action".')
    return
  end

  local path = core.path.normalize(condidate)
  if type(action) == 'string' then
    vim.command(action .. ' ' .. path)
  elseif type(action) == 'function' then
    local current = VFiler.get(vim.fn.bufnr())
    if current then
      current:do_action(function(filer, context, view)
        action(filer, context, view, path)
      end)
    else
      -- If the vfiler object does not exist,
      -- a dummy vfiler with default settings is generated.
      local dummy = new_dummy_vfiler(core.path.parent(path))
      dummy:do_action(function(filer, context, view)
        action(filer, context, view, path)
      end)
      dummy:wipeout()
    end
  else
    core.message.error('Action "%s" is no supported.', key)
  end
end

------------------------------------------------------------------------------
-- Actions
--

---  fzf Ag
function M.ag(vfiler, context, view)
  if vim.fn.executable('ag') == 0 then
    core.message.error('Not found "ag" command.')
    return
  end

  local pattern = input_pattern()
  if pattern == '' then
    return
  end
  execute('vfiler#fzf#ag', vfiler, view)
end

---  fzf Grep
function M.grep(vfiler, context, view)
  if vim.fn.executable('grep') == 0 then
    core.message.error('Not found "grep" command.')
    return
  end

  local pattern = input_pattern()
  if pattern == '' then
    return
  end
  execute('vfiler#fzf#grep', vfiler, view)
end

---  fzf Files
function M.files(vfiler, context, view)
  execute('vfiler#fzf#files', vfiler, view)
end

---  fzf Rg
function M.rg(vfiler, context, view)
  if vim.fn.executable('rg') == 0 then
    core.message.error('Not found "rg" command.')
    return
  end

  local pattern = input_pattern()
  if pattern == '' then
    return
  end
  execute('vfiler#fzf#rg', vfiler, view)
end

return M
