local M = {}

function M.focusPane(n)
  hs.application.launchOrFocus("Ghostty")
  local app = hs.application.find("Ghostty")
  if app then
    app:activate()
    hs.eventtap.keyStroke({"ctrl"}, "/", 0, app)
    hs.eventtap.keyStroke({}, tostring(n), 0, app)
  end
end

return M
