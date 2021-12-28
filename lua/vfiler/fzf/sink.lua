local action = require('vfiler/action')

local M = {}

function M.open(vfiler, context, view, path)
  action.open_file(vfiler, context, view, path, 'edit')
end

function M.open_by_split(vfiler, context, view, path)
  action.open_file(vfiler, context, view, path, 'bottom')
end

function M.open_by_vsplit(vfiler, context, view, path)
  action.open_file(vfiler, context, view, path, 'right')
end

function M.open_by_tabpage(vfiler, context, view, path)
  action.open_file(vfiler, context, view, path, 'tab')
end

function M.open_by_choose(vfiler, context, view, path)
  action.open_file(vfiler, context, view, path, 'choose')
end

return M
