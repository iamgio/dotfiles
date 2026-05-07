hs.autoLaunch(true)
hs.accessibilityState(true)
hs.ipc.cliInstall("/opt/homebrew")
hs.menuIcon(false)
hs.window.animationDuration = 0

local tmux = require("tmux")
local ide = require("ide")
local row = require("row")

row.bind("1", function(r) tmux.focusPane((r - 1) * 2 + 1) end)
row.bind("2", function(r) tmux.focusPane((r - 1) * 2 + 2) end)
row.bind("3", function(r) ide.focus("IntelliJ IDEA", r) end)

hs.hotkey.bind({"cmd", "alt"}, "1", function() row.enter(1) end)
hs.hotkey.bind({"cmd", "alt"}, "2", function() row.enter(2) end)
