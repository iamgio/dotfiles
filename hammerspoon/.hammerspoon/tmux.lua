local M = {}

local function tmux_pane(n)
  hs.osascript.applescript(string.format([[
    tell application "iTerm"
      activate
      tell current session of current window
        write text (character id 2) & "%d" without newline
      end tell
    end tell
  ]], n))
end

local paneModal = hs.hotkey.modal.new()
local currentRow = nil
local timeoutTimer = nil

local function enterRow(row)
  currentRow = row
  paneModal:enter()
  if timeoutTimer then timeoutTimer:stop() end
  timeoutTimer = hs.timer.doAfter(1.5, function() paneModal:exit() end)
end

local function selectCol(col)
  paneModal:exit()
  if timeoutTimer then timeoutTimer:stop() end
  tmux_pane((currentRow - 1) * 2 + col)
end

paneModal:bind({}, "1", function() selectCol(1) end)
paneModal:bind({}, "2", function() selectCol(2) end)
paneModal:bind({}, "escape", function() paneModal:exit() end)

function M.setup()
  hs.hotkey.bind({"cmd", "alt"}, "1", function() enterRow(1) end)
  hs.hotkey.bind({"cmd", "alt"}, "2", function() enterRow(2) end)
end

return M