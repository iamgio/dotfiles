local M = {}

function M.focus(appName, n)
  local app = hs.application.find(appName)
  if not app then return end
  app:activate()
  local windows = app:visibleWindows()
  table.sort(windows, function(a, b) return a:id() < b:id() end)
  if windows[n] then windows[n]:focus() end
end

return M
