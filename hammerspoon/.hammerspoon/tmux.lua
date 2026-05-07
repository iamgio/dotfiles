local M = {}

function M.focusPane(n)
  hs.osascript.applescript(string.format([[
    tell application "iTerm"
      activate
      tell current session of current window
        write text (character id 2) & "%d" without newline
      end tell
    end tell
  ]], n))
end

return M
