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

local current_scheme = nil

local function get_system_scheme()
    -- 1. Try DBus using GIO if lgi is available
    local has_lgi, lgi = pcall(require, "lgi")
    if has_lgi then
        local GLib = lgi.GLib
        local Gio = lgi.Gio
        local bus = Gio.bus_get_sync(Gio.BusType.SESSION, nil)
        if bus then
            local success, reply = pcall(function()
                return bus:call_sync(
                    "org.freedesktop.portal.Desktop",
                    "/org/freedesktop/portal/desktop",
                    "org.freedesktop.portal.Settings",
                    "Read",
                    GLib.Variant("(ss)", { "org.freedesktop.appearance", "color-scheme" }),
                    nil,
                    Gio.DBusCallFlags.NONE,
                    -1,
                    nil
                )
            end)
            if success and reply then
                local val_variant = reply:get_child_value(0):get_variant()
                local val = val_variant.value or val_variant:get_uint32()
                if val == 1 then
                    return "dark"
                elseif val == 2 then
                    return "light"
                end
            end
        end
    end

    -- 2. Fallback to gsettings color-scheme
    local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        result = result:gsub("%s+", "")
        if result == "'prefer-dark'" then
            return "dark"
        elseif result == "'default'" then
            return "light"
        end
    end

    -- 3. Fallback to gsettings gtk-theme name check
    local handle_gtk = io.popen("gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null")
    if handle_gtk then
        local result = handle_gtk:read("*a")
        handle_gtk:close()
        result = result:lower()
        if result:find("dark") or result:find("night") or result:find("black") or result:find("nord") or result:find("dracula") then
            return "dark"
        end
    end

    return "dark"
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
end

function M.setup(o)
    local opts = o or {}
    local color_opts = opts.ui and opts.ui.color or {}
    local scheme_mode = color_opts.scheme or "auto"
    local palette_name = color_opts.palette or "catppuccin"
    local custom_config = color_opts.custom

    -- Resolve initial scheme
    local active_scheme = "dark"
    if scheme_mode == "auto" then
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

    -- If auto, register DBus listener or fall back to polling
    if scheme_mode == "auto" then
        local has_lgi, lgi = pcall(require, "lgi")
        local dbus_subscribed = false

        if has_lgi then
            local GLib = lgi.GLib
            local Gio = lgi.Gio
            local bus = Gio.bus_get_sync(Gio.BusType.SESSION, nil)
            if bus then
                local success = pcall(function()
                    bus:signal_subscribe(
                        "org.freedesktop.portal.Desktop",
                        "org.freedesktop.portal.Settings",
                        "SettingChanged",
                        "/org/freedesktop/portal/desktop",
                        nil,
                        Gio.DBusSignalFlags.NONE,
                        function(conn, sender, path, interface, signal, parameters)
                            local namespace = parameters:get_child_value(0):get_string()
                            local key = parameters:get_child_value(1):get_string()
                            local val_variant = parameters:get_child_value(2):get_variant()
                            local val = val_variant.value or val_variant:get_uint32()

                            if namespace == "org.freedesktop.appearance" and key == "color-scheme" then
                                local new_scheme = (val == 1) and "dark" or "light"
                                if new_scheme ~= current_scheme then
                                    current_scheme = new_scheme
                                    apply_colors(palette_name, new_scheme, custom_config)
                                end
                            end
                        end
                    )
                end)
                if success then
                    dbus_subscribed = true
                    -- Start a non-blocking timer to iterate the GLib main context
                    local context = GLib.MainContext.default()
                    hl.timer(function()
                        while context:iteration(false) do end
                    end, { timeout = 1000, type = "repeat" })
                end
            end
        end

        -- Fallback polling if DBus library is not available or connection failed
        if not dbus_subscribed then
            hl.timer(function()
                local new_scheme = get_system_scheme()
                if new_scheme ~= current_scheme then
                    current_scheme = new_scheme
                    apply_colors(palette_name, new_scheme, custom_config)
                end
            end, { timeout = 3000, type = "repeat" })
        end
    end
end

return M
