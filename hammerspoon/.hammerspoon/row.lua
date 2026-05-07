local M = {}

local modal = hs.hotkey.modal.new()
local currentRow = nil
local timeoutTimer = nil

function M.enter(row)
  currentRow = row
  modal:enter()
  if timeoutTimer then timeoutTimer:stop() end
  timeoutTimer = hs.timer.doAfter(1.5, function() modal:exit() end)
end

function M.bind(key, fn)
  modal:bind({}, key, function()
    modal:exit()
    if timeoutTimer then timeoutTimer:stop() end
    fn(currentRow)
  end)
end

modal:bind({}, "escape", function() modal:exit() end)

return M
