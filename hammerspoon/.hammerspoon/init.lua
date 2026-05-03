hs.autoLaunch(true)
hs.ipc.cliInstall("/opt/homebrew")
hs.menuIcon(false)
hs.window.animationDuration = 0

require("tmux").setup()