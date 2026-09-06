-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

-- Fetch home directory dynamically
local home = os.getenv("HOME")

-- Inject User LuaRocks paths (for --user installs)
package.path = home .. "/.luarocks/share/lua/5.2/?.lua;" .. home .. "/.luarocks/share/lua/5.2/?/init.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.2/?.so;" .. package.cpath

local cfg = require('config')
cfg.init()

local monitors = require('modules.monitors')
local keybinds = require('modules.keybinds')
local input = require('modules.input')
local ui = require('modules.ui')
local graphics = require('modules.graphics')
local system = require('modules.system')
local autostart = require('modules.autostart')

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QUICK_BACKEND", "vulkan")

system.setup(cfg)
autostart.setup(cfg)
graphics.setup(cfg)
monitors.setup(cfg)
keybinds.setup(cfg)
input.setup(cfg)
ui.setup(cfg)

require('override')
