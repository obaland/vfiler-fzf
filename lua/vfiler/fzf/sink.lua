local action = require 'vfiler/action'
local vim = require 'vfiler/vim'

local VFiler = require 'vfiler/vfiler'

local M = {}

function M.open(vfiler, path)
  action.open_file(vfiler, path, 'edit')
end

function M.open_by_split(vfiler, path)
  action.open_file(vfiler, path, 'bottom')
end

function M.open_by_vsplit(vfiler, path)
  action.open_file(vfiler, path, 'right')
end

function M.open_by_tabpage(vfiler, path)
  action.open_file(vfiler, path, 'tab')
end

function M.open_by_choose(vfiler, path)
  action.open_file(vfiler, path, 'choose')
end

return M
