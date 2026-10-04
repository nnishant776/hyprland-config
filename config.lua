---@class KeybindSpec
---@field key string
---@field dispatcher function|HL.Dispatcher
---@field options HL.BindOptions

---@class DesignatedPrograms
---@field Terminal string|function
---@field FileManager string|function
---@field Menu string|function

---@class KeyboardConfigSpec
---@field kb_layout string

---@class MouseConfigSpec
---@field accel_profile string

---@class TouchpadConfigSpec
---@field natural_scroll boolean

---@class PointingDeviceConfig
---@field mouse MouseConfigSpec
---@field touchpad TouchpadConfigSpec

---@class InputConfigSpec
---@field keyboardDevice KeyboardConfigSpec
---@field pointingDevice PointingDeviceConfig

---@class DwindleLayoutSpec
---@field preserve_all_split boolean

---@class MasterLayoutSpec
---@field new_status string

---@class ScrollingLayoutSpec
---@field fullscreen_on_one_column boolean

---@class LayoutConfigSpec
---@field name string
---@field master table
---@field dwindle table
---@field scrolling table

---@class AnimationSpec
---@field enabled boolean
---@field bezier? string
---@field spring? string
---@field style? string
---@field speed? number

---@class CurveSpec
---@field type string
---@field points? number[][]
---@field mass? number
---@field stiffness? number
---@field dampening? number

---@class AnimationConfigSpec
---@field enable boolean
---@field rules table<string, AnimationSpec>
---@field curves table<string, CurveSpec>

---@class FontConfigSpec
---@field family string
---@field size integer

---@class BorderConfigSpec
---@field gaps_in integer
---@field gaps_out integer
---@field border_size integer
---@field resize_on_border boolean

---@class WindowConfigSpec
---@field border BorderConfigSpec

---@class CursorConfigSpec
---@field enable_hyprcursor boolean
---@field hide_on_key_press boolean

---@class UIConfigSpec
---@field customShells CustomShellSpec
---@field animation AnimationConfigSpec
---@field font FontConfigSpec
---@field layout LayoutConfigSpec
---@field cursor CursorConfigSpec

---@class CustomShellSpec
---@field variant string
---@field variantRegistry table<string, CustomShellVariantSpec>

---@class CustomShellVariantSpec
---@field startCmd string[]

---@class SystemConfigSpec
---@field timezone string
---@field local string

---@class HyprlandConfig
---@field autostart string[]
---@field screens HL.MonitorSpec[]
---@field programs DesignatedPrograms
---@field keybinds KeybindSpec[]
---@field input InputConfigSpec
---@field ui UIConfigSpec

---@class HyprlandConfig
local M = {
    MainMod = "SUPER",
}

M.programs = {
    Terminal = "alacritty",
    FileManager = "nautilus",
    Menu = "hyprlauncher",
}

M.autostart = {
    -- "waybar",
    -- "hypridle",
}

M.screens = {}

M.keybinds = {
    -- Application Launch
    { key = M.MainMod .. " + Return",         dispatcher = hl.dsp.exec_cmd(M.programs.Terminal),                                            options = {} },
    { key = M.MainMod .. " + E",              dispatcher = hl.dsp.exec_cmd(M.programs.FileManager),                                         options = {} },
    { key = M.MainMod .. " + A",              dispatcher = hl.dsp.exec_cmd(M.programs.Menu),                                                options = {} },

    -- Session Control
    { key = "CTRL + ALT + DELETE",            dispatcher = hl.dsp.exec_cmd("loginctl terminate-user $USER"),                                options = {} },

    -- Window Control
    { key = M.MainMod .. " + CTRL + Q",       dispatcher = hl.dsp.window.kill(),                                                            options = {} },
    { key = M.MainMod .. " + ALT + F",        dispatcher = hl.dsp.window.fullscreen_state({ internal = 0, client = 2, action = "toggle" }), options = {} },
    { key = M.MainMod .. " + CTRL + F",       dispatcher = hl.dsp.window.fullscreen_state({ internal = 1, client = 1, action = "toggle" }), options = {} },
    { key = M.MainMod .. " + CTRL + ALT + F", dispatcher = hl.dsp.window.fullscreen_state({ internal = 1, client = 2, action = "toggle" }), options = {} },
    { key = M.MainMod .. " + CTRL + F11",     dispatcher = hl.dsp.window.fullscreen_state({ internal = 2, client = 2, action = "toggle" }), options = {} },
    { key = M.MainMod .. " + H",              dispatcher = hl.dsp.focus({ direction = "left" }),                                            options = {} },
    { key = M.MainMod .. " + J",              dispatcher = hl.dsp.focus({ direction = "down" }),                                            options = {} },
    { key = M.MainMod .. " + K",              dispatcher = hl.dsp.focus({ direction = "up" }),                                              options = {} },
    { key = M.MainMod .. " + L",              dispatcher = hl.dsp.focus({ direction = "right" }),                                           options = {} },
    { key = M.MainMod .. " + CTRL + V",       dispatcher = hl.dsp.window.float({ action = "toggle" }),                                      options = {} },
    { key = M.MainMod .. " + Left",           dispatcher = hl.dsp.window.move({ direction = "left" }),                                      options = {} },
    { key = M.MainMod .. " + Down",           dispatcher = hl.dsp.window.move({ direction = "down" }),                                      options = {} },
    { key = M.MainMod .. " + Up",             dispatcher = hl.dsp.window.move({ direction = "up" }),                                        options = {} },
    { key = M.MainMod .. " + Right",          dispatcher = hl.dsp.window.move({ direction = "right" }),                                     options = {} },
    {
        key = M.MainMod .. " + SHIFT + Left",  -- Only for scrolling layout
        dispatcher = function()
            if M.ui.layout.name == "scrolling" then
                hl.dispatch(hl.dsp.layout("swapcol l"))
            end
        end,
        options = {},
    },
    {
        key = M.MainMod .. " + SHIFT + Right",  -- Only for scrolling layout
        dispatcher = function()
            if M.ui.layout.name == "scrolling" then
                hl.dispatch(hl.dsp.layout("swapcol r"))
            end
        end,
        options = {},
    },
    {
        key = M.MainMod .. " + SHIFT + Equal",
        dispatcher = function()
            if M.ui.layout.name == "scrolling" then
                hl.dispatch(hl.dsp.layout("colresize +conf"))
            else
                hl.dsp.window.move({ direction = "right" })
            end
        end,
        options = {},
    },
    {
        key = M.MainMod .. " + SHIFT + Minus",
        dispatcher = function()
            if M.ui.layout.name == "scrolling" then
                hl.dispatch(hl.dsp.layout("colresize -conf"))
            else
                hl.dsp.window.move({ direction = "right" })
            end
        end,
        options = {},
    },
    { key = M.MainMod .. " + CTRL + T",       dispatcher = hl.dsp.group.toggle(),                                                           options = {} },
    { key = M.MainMod .. " + SHIFT + H",      dispatcher = hl.dsp.group.move_window(),                                                      options = {} },
    { key = M.MainMod .. " + mouse:272",      dispatcher = hl.dsp.window.drag(),                                                            options = { mouse = true} },
    { key = M.MainMod .. " + mouse:273",      dispatcher = hl.dsp.window.resize(),                                                          options = { mouse = true} },
    {
        key = M.MainMod .. " + ALT + R",
        dispatcher = hl.dsp.submap("resize"),
        options = {},
        submapKey = "resize",
        submaps = {
            { key = "left",      dispatcher = hl.dsp.window.resize({ x = -10, y = 0, relative = true }), options = { repeating = true } },
            { key = "right",     dispatcher = hl.dsp.window.resize({ x = 10, y = 0, relative = true }),  options = { repeating = true } },
            { key = "down",      dispatcher = hl.dsp.window.resize({ x = 0, y = 10, relative = true }),  options = { repeating = true } },
            { key = "up",        dispatcher = hl.dsp.window.resize({ x = 0, y = -10, relative = true }), options = { repeating = true } },
            { key = "escape",    dispatcher = hl.dsp.submap("reset"),                                    options = { repeating = true } },
        },
    },

    -- Workspace Controls
    { key = M.MainMod .. " + Page_Down",      dispatcher = hl.dsp.focus({ workspace = "r+1" }),                                             options = {} },
    { key = M.MainMod .. " + Page_Up",        dispatcher = hl.dsp.focus({ workspace = "r-1" }),                                             options = {} },
    { key = M.MainMod .. " + mouse_down",     dispatcher = hl.dsp.focus({ workspace = "e+1" }),                                             options = {} },
    { key = M.MainMod .. " + mouse_up",       dispatcher = hl.dsp.focus({ workspace = "e-1" }),                                             options = {} },

    -- Multimedia Controls
    { key = "XF86AudioRaiseVolume",           dispatcher = hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),               options = { locked = true, repeating = true } },
    { key = "XF86AudioLowerVolume",           dispatcher = hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"),               options = { locked = true, repeating = true } },
    { key = "XF86AudioMute",                  dispatcher = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),                   options = { locked = true, repeating = true } },
    { key = "XF86AudioMicMute",               dispatcher = hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),                 options = { locked = true, repeating = true } },
    { key = "XF86AudioNext",                  dispatcher = hl.dsp.exec_cmd("playerctl next"),                                               options = { locked = true, repeating = true } },
    { key = "XF86AudioPrev",                  dispatcher = hl.dsp.exec_cmd("playerctl previous"),                                           options = { locked = true, repeating = true } },
    { key = "XF86AudioPlay",                  dispatcher = hl.dsp.exec_cmd("playerctl play-pause"),                                         options = { locked = true, repeating = true } },
    { key = "XF86AudioPause",                 dispatcher = hl.dsp.exec_cmd("playerctl play-pause"),                                         options = { locked = true, repeating = true } },
    { key = "XF86MonBrightnessUp",            dispatcher = hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                                options = { locked = true, repeating = true } },
    { key = "XF86MonBrightnessDown",          dispatcher = hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                                options = { locked = true, repeating = true } },

    -- Screen Controls
    {
        key = M.MainMod .. " + Z",
        dispatcher = function()
            local zoomOffset = 0.1
            local currentZoom = hl.get_config("cursor.zoom_factor")
            currentZoom = currentZoom + zoomOffset
            hl.config({ cursor = { zoom_factor = currentZoom } })
        end,
        options = { repeating = true },
    },
    {
        key = M.MainMod .. " + SHIFT + Z",
        dispatcher = function()
            local zoomOffset = -0.1
            local currentZoom = hl.get_config("cursor.zoom_factor")
            currentZoom = currentZoom + zoomOffset
            hl.config({ cursor = { zoom_factor = currentZoom } })
        end,
        options = { repeating = true },
    }
}

M.system = {
    timezone = "Asia/Kolkata",
    locale = "en_IN",
}

M.input = {
    keyboardDevice = {
        kb_layout = "us",
    },
    pointingDevice = {
        mouse = {
            accel_profile = "",
            sensitivity = 0
        },
        touchpad = {
            natural_scroll = true,
        },
        gestures = {
            {
                fingers = 3,
                direction = "up",
                action = function()
                    hl.dispatch(hl.dsp.window.fullscreen_state({
                        internal = 2,
                        client = 2,
                        action = "toggle",
                    }))
                end
            },
            {
                fingers = 3,
                direction = "left",
                action = function()
                    local direction = "left"
                    local config = require('config')
                    if config.input.pointingDevice.touchpad.natural_scroll then
                        direction = "right"
                    end
                    hl.dispatch(hl.dsp.focus({ direction = direction }))
                end
            },
            {
                fingers = 3,
                direction = "right",
                action = function()
                    local direction = "right"
                    local config = require('config')
                    if config.input.pointingDevice.touchpad.natural_scroll then
                        direction = "left"
                    end
                    hl.dispatch(hl.dsp.focus({ direction = direction }))
                end
            },
            {
                fingers = 3,
                direction = "down",
                action = function()
                    hl.notification.create({
                        text = "I just swiped on my trackpad!",
                        timeout = 5000,
                        icon = "ok",
                    })
                end
            },
            {
                fingers = 2,
                direction = "pinchin",
                action = "cursorZoom",
                zoom_level = 1.1,
                mode = "mult",
                mods = M.MainMod,
            },
            {
                fingers = 2,
                direction = "pinchout",
                action = "cursorZoom",
                zoom_level = 0.9,
                mode = "mult",
                mods = M.MainMod,
            },
            {
                fingers = 4,
                direction = "up",
                action = function()
                    local direction = "-1"
                    local config = require('config')
                    if config.input.pointingDevice.touchpad.natural_scroll then
                        direction = "+1"
                    end
                    hl.dispatch(hl.dsp.focus({ workspace = "e" .. direction }))
                end,
            },
            {
                fingers = 4,
                direction = "down",
                action = function()
                    local direction = "-1"
                    local config = require('config')
                    if config.input.pointingDevice.touchpad.natural_scroll then
                        direction = "+1"
                    end
                    hl.dispatch(hl.dsp.focus({ workspace = "e" .. direction }))
                end,
            },
        },
    },
}

M.graphics = {
    force_zero_scaling = true,
    allow_tearing = false,
    vrr = 0,
}

M.ui = {
    customShells = {
        variant = "noctalia",
        variantRegistry = {
            noctalia = {
                startCmd = { "noctalia" },
            },
            caelestica = {
                startCmd = { "caelestia-shell" },
            },
            dms = {
                startCmd = { "dms", "run" },
            },
        },
    },
    color = {
        scheme = "auto", -- "auto" (detects system dark/light theme dynamically) | "dark" | "light"
        palette = "one", -- "catppuccin" | "nord" | "everforest" | "gruvbox" | "solarized" | "tokyonight" | "custom"
    },
    font = {
        family = "SF Pro 11 @opcz=17",
        size = 13,
    },
    animation = {
        enable = true,
        rules = {
            { leaf = "global",        enabled = true,  speed = 10,   bezier = "default"                                   },
            { leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint"                              },
            { leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy"                                      },
            { leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%"         },
            { leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%"         },
            { leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear"                              },
            { leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear"                              },
            { leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick"                                     },
            { leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint"                              },
            { leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade"              },
            { leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade"              },
            { leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear"                              },
            { leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear"                              },
            { leaf = "workspaces",    enabled = true,  speed = 1.5,  bezier = "quick",        style = "slidevert"         },
            { leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "quick",        style = "slidevert"         },
            { leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "quick",        style = "slidevert"         },
            { leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick"                                     },
        },
        curves = {
            easy           = { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 },
            easeOutQuint   = { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } },
            easeInOutCubic = { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } },
            linear         = { type = "bezier", points = { {0, 0},       {1, 1}       } },
            almostLinear   = { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } },
            quick          = { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } },
        },
    },
    layout = {
        name = "scrolling",
        master = {
            new_status = "master",
        },
        scrolling = {
            fullscreen_on_one_column = true,
            wrap_focus = false,
            wrap_swapcol = false,
        },
        dwindle = {
            preserve_split = true, -- You probably want this
        },
    },
    window = {
        border = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = 1;
            color = {},
            resize_on_border = true,
            extend_border_grab_area = 20,
        },
        focus = {
            no_focus_fallback = true,
            follow_mouse = 1,
        },
        snapping = {
            enabled = true,
            window_gap = 10,
            monitor_gap = 10,
            border_overlap = false,
            respect_gaps = true,
        },
        group = {
            col = {
                border_active = 0x33ccffff,
                border_inactive = 0x595959ff,
            },
            groupbar = {
                enabled = true,
                height = 20,
                font_size = 14,
                render_titles = true,
                col = {
                    active = 0x33ccffff,
                    inactive = 0x595959ff,
                    locked_active = 0x33ccffff,
                    locked_inactive = 0x595960ff,
                },
            },
        },
        rules = {
            {
                name  = "no-gaps-wtv1",
                match = { float = false, workspace = "w[tv1]" },
                border_size = 0,
            },
            {
                name  = "no-gaps-f1",
                match = { float = false, workspace = "f[1]" },
                border_size = 0,
            },
            {
                name = "no-border-internal-maximized-windows",
                match = { fullscreen_state_internal = 1 },
                border_size = 0,
            },
            {
                name  = "no-dim-media-playback",
                match = { class = "^$" },
                no_dim = true,
            },
            {
                name  = "no-dim-browser",
                match = { class = "^(firefox|chrome|chromium-browser)$" },
                no_dim = true,
            },
            {
                -- Fix some dragging issues with XWayland
                name  = "fix-xwayland-drags",
                match = {
                    class      = "^$",
                    title      = "^$",
                    xwayland   = true,
                    float      = true,
                    fullscreen = false,
                    pin        = false,
                },

                no_focus = true,
            },
            {
                -- Ignore maximize requests from all apps. You'll probably like this.
                name  = "suppress-maximize-events",
                match = { class = ".*" },
                suppress_event = "maximize",
            },
            {
                name = "float-windows-with-no-class",
                match = { class = "^$" },
                float = true,
            }
        },
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },
    cursor = {
        enable_hyprcursor = false,
		hide_on_key_press = true,
    },
    decoration = {
        rounding       = 0,
        rounding_power = 0,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        -- inactive_opacity = 0.9,
        inactive_opacity = 1.0,

        dim_modal = true,
        dim_inactive = false,
        dim_strength = 0.1,

        shadow = {
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = false,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },
    workspace = {
        rules = {
            { workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 },
            { workspace = "f[1]",   gaps_out = 0, gaps_in = 0 },
        },
    },
}

function M.init()
    -- Load the plugins
    utils.LoadPluginsFromDir(os.getenv("HYPR_PLUGIN_DIR"))

    -- Load runtime configuration
    pcall(require, 'runtime')

    -- Config initialisation and setup
    if M.ui.customShells.variant ~= "" and M.ui.customShells.variant ~= "none" then
        local variantInfo = M.ui.customShells.variantRegistry[M.ui.customShells.variant]
        if variantInfo then
            local cmd = table.concat(variantInfo.startCmd, " ")
            table.insert(M.autostart, cmd)
        end
    end
end

return M
