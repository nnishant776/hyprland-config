local M = {}

local function make_top_fade_gradient(color_str)
    return {
        colors = {
            "rgba(00000000)",
            color_str, color_str, color_str,
            color_str, color_str, color_str, color_str
        },
        angle = 90
    }
end

local palettes = {
    catppuccin = {
        dark = {
            active_border   = make_top_fade_gradient("rgba(b4befeee)"),
            inactive_border = "rgba(585b70aa)",
            group_border_active = "rgba(b4befeee)",
            group_border_inactive = "rgba(585b70aa)",
            groupbar_active = "rgba(b4befeee)",
            groupbar_inactive = "rgba(313244ee)",
            shadow = "rgba(00000066)",
        },
        light = {
            active_border   = make_top_fade_gradient("rgba(7287fdee)"),
            inactive_border = "rgba(acb0beaa)",
            group_border_active = "rgba(7287fdee)",
            group_border_inactive = "rgba(acb0beaa)",
            groupbar_active = "rgba(7287fdee)",
            groupbar_inactive = "rgba(e6e9efee)",
            shadow = "rgba(00000022)",
        }
    },
    nord = {
        dark = {
            active_border   = make_top_fade_gradient("rgba(88c0d0ee)"),
            inactive_border = "rgba(4c566aaa)",
            group_border_active = "rgba(88c0d0ee)",
            group_border_inactive = "rgba(4c566aaa)",
            groupbar_active = "rgba(88c0d0ee)",
            groupbar_inactive = "rgba(3b4252ee)",
            shadow = "rgba(00000055)",
        },
        light = {
            active_border   = make_top_fade_gradient("rgba(5e81acee)"),
            inactive_border = "rgba(d8dee9aa)",
            group_border_active = "rgba(5e81acee)",
            group_border_inactive = "rgba(d8dee9aa)",
            groupbar_active = "rgba(5e81acee)",
            groupbar_inactive = "rgba(eceff4ee)",
            shadow = "rgba(00000015)",
        }
    },
    everforest = {
        dark = {
            active_border   = make_top_fade_gradient("rgba(a7c080ee)"),
            inactive_border = "rgba(4f585eaa)",
            group_border_active = "rgba(a7c080ee)",
            group_border_inactive = "rgba(4f585eaa)",
            groupbar_active = "rgba(a7c080ee)",
            groupbar_inactive = "rgba(2d353bee)",
            shadow = "rgba(00000055)",
        },
        light = {
            active_border   = make_top_fade_gradient("rgba(8da101ee)"),
            inactive_border = "rgba(dfddc8aa)",
            group_border_active = "rgba(8da101ee)",
            group_border_inactive = "rgba(dfddc8aa)",
            groupbar_active = "rgba(8da101ee)",
            groupbar_inactive = "rgba(f2efd9ee)",
            shadow = "rgba(00000015)",
        }
    },
    gruvbox = {
        dark = {
            active_border   = make_top_fade_gradient("rgba(fabd2fee)"),
            inactive_border = "rgba(504945aa)",
            group_border_active = "rgba(fabd2fee)",
            group_border_inactive = "rgba(504945aa)",
            groupbar_active = "rgba(fabd2fee)",
            groupbar_inactive = "rgba(282828ee)",
            shadow = "rgba(00000066)",
        },
        light = {
            active_border   = make_top_fade_gradient("rgba(d79921ee)"),
            inactive_border = "rgba(d5c4a1aa)",
            group_border_active = "rgba(d79921ee)",
            group_border_inactive = "rgba(d5c4a1aa)",
            groupbar_active = "rgba(d79921ee)",
            groupbar_inactive = "rgba(fbf1c7ee)",
            shadow = "rgba(00000022)",
        }
    },
    solarized = {
        dark = {
            active_border   = make_top_fade_gradient("rgba(2aa198ee)"),
            inactive_border = "rgba(073642aa)",
            group_border_active = "rgba(2aa198ee)",
            group_border_inactive = "rgba(073642aa)",
            groupbar_active = "rgba(2aa198ee)",
            groupbar_inactive = "rgba(002b36ee)",
            shadow = "rgba(00000077)",
        },
        light = {
            active_border   = make_top_fade_gradient("rgba(2aa198ee)"),
            inactive_border = "rgba(eee8d5aa)",
            group_border_active = "rgba(2aa198ee)",
            group_border_inactive = "rgba(eee8d5aa)",
            groupbar_active = "rgba(2aa198ee)",
            groupbar_inactive = "rgba(fdf6e3ee)",
            shadow = "rgba(00000015)",
        }
    },
    tokyonight = {
        dark = {
            active_border   = make_top_fade_gradient("rgba(bb9af7ee)"),
            inactive_border = "rgba(3b4261aa)",
            group_border_active = "rgba(bb9af7ee)",
            group_border_inactive = "rgba(3b4261aa)",
            groupbar_active = "rgba(bb9af7ee)",
            groupbar_inactive = "rgba(16161eee)",
            shadow = "rgba(00000066)",
        },
        light = {
            active_border   = make_top_fade_gradient("rgba(9854f1ee)"),
            inactive_border = "rgba(e1e2e7aa)",
            group_border_active = "rgba(9854f1ee)",
            group_border_inactive = "rgba(e1e2e7aa)",
            groupbar_active = "rgba(9854f1ee)",
            groupbar_inactive = "rgba(f5f6f9ee)",
            shadow = "rgba(00000015)",
        }
    },
    -- One Dark / One Light  (Atom-inspired)
    one = {
        dark = {
            -- One Dark: blue #61afef, purple #c678dd, inactive surface #3e4452
            active_border   = make_top_fade_gradient("rgba(61afefee)"),
            inactive_border = "rgba(3e4452aa)",
            group_border_active = "rgba(61afefee)",
            group_border_inactive = "rgba(3e4452aa)",
            groupbar_active = "rgba(61afefee)",
            groupbar_inactive = "rgba(282c34ee)",
            shadow = "rgba(00000066)",
        },
        light = {
            -- One Light: blue #4078f2, purple #a626a4, inactive surface #d3d3d3
            active_border   = make_top_fade_gradient("rgba(4078f2ee)"),
            inactive_border = "rgba(d3d3d3aa)",
            group_border_active = "rgba(4078f2ee)",
            group_border_inactive = "rgba(d3d3d3aa)",
            groupbar_active = "rgba(4078f2ee)",
            groupbar_inactive = "rgba(fafafaee)",
            shadow = "rgba(00000018)",
        }
    }
}

-- dconf is used instead of gsettings since it doesn't need the GSettings schemas in XDG_DATA_DIRS
local SCHEME_KEY = "/org/gnome/desktop/interface/color-scheme"
local CURSOR_KEY = "/org/gnome/desktop/interface/cursor-theme"

-- Calls M.refresh() inside Hyprland on every color-scheme change. hyprctl only fails once
-- Hyprland is gone (Lua errors still exit 0), which stops the watcher.
local WATCHER_CMD = "dconf watch " .. SCHEME_KEY .. [[ | while read -r line; do case "$line" in /*) ]]
    .. [[hyprctl eval "require('modules.ui.color').refresh()" >/dev/null 2>&1 || exit 0 ;; esac; done]]

-- Substring swaps that give the cursor theme the opposite variant of the color scheme
local cursor_swaps = {
    dark = { { "dark", "light" }, { "night", "day" }, { "black", "white" } },
    light = { { "light", "dark" }, { "day", "night" }, { "white", "black" } },
}

-- Kept at module level so M.refresh() can re-apply with the settings from setup()
local current_scheme = nil
local auto_scheme = false
local current_palette_name = nil
local current_custom_config = nil

-- Shell-specific extras (see customisations/), run with the scheme name on every change
local scheme_hooks = {}

local function shell_quote(s)
    return "'" .. s:gsub("'", "'\\''") .. "'"
end

---@param key string
---@return string|nil value GVariant text such as "'prefer-dark'", "" if unset, nil on failure
local function dconf_read(key)
    -- close() can't report the exit status inside Hyprland since it reaps children itself
    -- (ECHILD), so the shell appends the status to the output instead
    local handle = io.popen("dconf read " .. key .. " 2>/dev/null; echo $?")
    if not handle then
        return nil
    end

    local output = handle:read("*a")
    handle:close()

    local value, status = output:match("^(.-)%s*(%d+)%s*$")
    if status ~= "0" then
        return nil
    end

    return value
end

---@param key string
---@param value string GVariant text such as "'Adwaita'"
local function dconf_write(key, value)
    os.execute("dconf write " .. key .. " " .. shell_quote(value))
end

local function get_system_scheme()
    local value = dconf_read(SCHEME_KEY)
    if value == nil then
        return current_scheme or "dark"
    end

    -- 'prefer-light', 'default' and unset all mean light
    return value == "'prefer-dark'" and "dark" or "light"
end

local function update_cursor_theme(scheme_name)
    local value = dconf_read(CURSOR_KEY)
    if not value or value == "" then
        return
    end

    local theme = value:gsub("^'(.*)'$", "%1")
    local new_theme = theme
    for _, swap in ipairs(cursor_swaps[scheme_name] or {}) do
        new_theme = new_theme:gsub(swap[1], swap[2])
    end
    if new_theme == theme then
        return
    end

    -- dconf for GTK apps, setcursor for Hyprland itself. setcursor must go through
    -- hl.exec_cmd: a blocking os.execute would deadlock waiting on Hyprland's own socket.
    dconf_write(CURSOR_KEY, "'" .. new_theme .. "'")
    hl.exec_cmd("hyprctl setcursor " .. shell_quote(new_theme) .. " " .. (os.getenv("XCURSOR_SIZE") or "24"))
end

local function apply_colors(palette_name, scheme_name, custom_config)
    local palette = palettes[palette_name]
    if palette_name == "custom" and custom_config then
        palette = custom_config
    elseif not palette then
        palette = palettes["catppuccin"]
    end

    local colors = palette[scheme_name] or palette["dark"]

    local config = {
        general = {
            col = {
                active_border = colors.active_border,
                inactive_border = colors.inactive_border,
            }
        },
        group = {
            col = {
                border_active = colors.group_border_active,
                border_inactive = colors.group_border_inactive,
                border_locked_active = colors.group_border_active,
                border_locked_inactive = colors.group_border_inactive,
            },
            groupbar = {
                col = {
                    active = colors.groupbar_active,
                    inactive = colors.groupbar_inactive,
                    locked_active = colors.groupbar_active,
                    locked_inactive = colors.groupbar_inactive,
                }
            }
        },
        decoration = {
            shadow = {
                color = colors.shadow
            }
        }
    }

    hl.config(config)

    -- Custom actions for applications that don't support dynamic themeing
    -- Update Alacritty theme by rewriting the import path in alacritty.toml
    local home = os.getenv("HOME")
    local alacritty_cfg = home .. "/.config/alacritty/alacritty.toml"
    local theme_filename = palette_name .. "_" .. scheme_name .. ".toml"
    local theme_path = "~/.config/alacritty/themes/themes/" .. theme_filename

    local f_in = io.open(alacritty_cfg, "r")
    if f_in then
        local content = f_in:read("*a")
        f_in:close()
        -- Replace any existing themes/themes/<name>.toml import line
        local new_content = content:gsub(
            '"[^"]*themes/themes/[^"]*%.toml"',
            '"' .. theme_path .. '"'
        )
        if new_content ~= content then
            local f_out = io.open(alacritty_cfg, "w")
            if f_out then
                f_out:write(new_content)
                f_out:close()
            end
        end
    end

    update_cursor_theme(scheme_name)

    for _, hook in ipairs(scheme_hooks) do
        hook(scheme_name)
    end
end

M.dconf_read = dconf_read
M.dconf_write = dconf_write

--- Registers hook(scheme_name), called right away with the current scheme and again on every
--- change. Config reloads start from a fresh Lua state, so hooks never pile up.
---@param hook fun(scheme_name: string)
function M.on_scheme_change(hook)
    table.insert(scheme_hooks, hook)
    if current_scheme then
        hook(current_scheme)
    end
end

--- Re-reads the system color scheme and re-applies colors if it changed.
--- Called by the dconf watcher through `hyprctl eval`.
function M.refresh()
    -- DMS writes 'default' (no preference) for light mode. Chromium reads that as
    -- "judge the GTK theme", judged at the instant the value changes, before the
    -- scheme hooks below have swapped gtk-theme to the light variant, and it does
    -- not judge again: it stays dark after every light toggle. 'prefer-light' is
    -- explicit, DMS leaves it alone, and the watcher re-fires once for this write.
    if dconf_read(SCHEME_KEY) == "'default'" then
        dconf_write(SCHEME_KEY, "'prefer-light'")
    end

    if not auto_scheme then
        return
    end

    local new_scheme = get_system_scheme()
    if new_scheme ~= current_scheme then
        current_scheme = new_scheme
        apply_colors(current_palette_name, new_scheme, current_custom_config)
    end
end

function M.setup(o)
    local opts = o or {}
    local color_opts = opts.ui and opts.ui.color or {}
    local scheme_mode = color_opts.scheme or "auto"
    local palette_name = color_opts.palette or "catppuccin"
    local custom_config = color_opts.custom

    auto_scheme = scheme_mode == "auto"
    current_palette_name = palette_name
    current_custom_config = custom_config

    -- Resolve initial scheme
    local active_scheme = "dark"
    if auto_scheme then
        active_scheme = get_system_scheme()
    else
        active_scheme = scheme_mode
    end

    current_scheme = active_scheme

    -- Inject colors directly into the configuration options object.
    -- This ensures other UI modules receive these values when setup() runs.
    local palette = palettes[palette_name]
    if palette_name == "custom" and custom_config then
        palette = custom_config
    elseif not palette then
        palette = palettes["catppuccin"]
    end
    local colors = palette[active_scheme] or palette["dark"]

    if opts.ui and opts.ui.window and opts.ui.window.border then
        opts.ui.window.border.color = {
            active_border = colors.active_border,
            inactive_border = colors.inactive_border,
        }
    end

    if opts.ui and opts.ui.window and opts.ui.window.group then
        opts.ui.window.group.col = {
            border_active = colors.group_border_active,
            border_inactive = colors.group_border_inactive,
            border_locked_active = colors.group_border_active,
            border_locked_inactive = colors.group_border_inactive,
        }
        opts.ui.window.group.groupbar.col = {
            active = colors.groupbar_active,
            inactive = colors.groupbar_inactive,
            locked_active = colors.groupbar_active,
            locked_inactive = colors.groupbar_inactive,
        }
    end

    if opts.ui and opts.ui.decoration and opts.ui.decoration.shadow then
        opts.ui.decoration.shadow.color = colors.shadow
    end

    -- If auto, follow dconf changes for the rest of the session. hyprland.start fires once,
    -- so config reloads don't spawn extra watchers.
    if auto_scheme then
        hl.on("hyprland.start", function()
            hl.exec_cmd(WATCHER_CMD)
        end)
    end
end

return M
