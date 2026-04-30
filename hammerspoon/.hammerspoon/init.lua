hs.autoLaunch(true)
hs.ipc.cliInstall("/opt/homebrew")
hs.menuIcon(false)
hs.window.animationDuration = 0

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

hs.hotkey.bind({"cmd", "alt"}, "1", function() tmux_pane(1) end)
hs.hotkey.bind({"cmd", "alt"}, "2", function() tmux_pane(2) end)
hs.hotkey.bind({"cmd", "alt"}, "3", function() tmux_pane(3) end)
hs.hotkey.bind({"cmd", "alt"}, "4", function() tmux_pane(4) end)