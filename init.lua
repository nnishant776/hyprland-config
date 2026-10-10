local home = os.getenv("HOME")

local cfg = require('config')
cfg.init()

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QUICK_BACKEND", "vulkan")

require('modules.monitors').setup(cfg)
require('modules.keybinds').setup(cfg)
require('modules.input').setup(cfg)
require('modules.ui').setup(cfg)
require('modules.graphics').setup(cfg)
require('modules.autostart').setup(cfg)
require('modules.monitors').setup(cfg)
require('modules.system').setup(cfg)

require('override')
