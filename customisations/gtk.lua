-- Live dark/light GTK theming from the shell's palette, shared by customisations/dms/gtk.lua and
-- customisations/noctalia/gtk.lua (each loaded only for its shell, which renders the templates).
--
-- GTK reads user CSS (gtk-3.0/gtk.css, gtk-4.0/gtk.css) only at app startup, so the shells' own
-- single-mode imports there pin apps to the mode they started in. Instead the shell renders the
-- palette below for both modes, and:
--   * GTK3 and plain GTK4 apps get the themes <name> and <name>-dark (adw-gtk3 plus the palette),
--     switched through gtk-theme on every toggle: GTK re-reads a theme whenever its name changes.
--     adw-gtk3 is needed because GTK's built-in themes ignore the palette's color names.
--   * libadwaita apps ignore gtk-theme, so gtk-4.0/gtk.css imports hypr-colors.css instead, which
--     holds both palettes with the dark one in a prefers-color-scheme media query, the way
--     libadwaita's own stylesheet does. It switches live without being re-read.
-- Without adw-gtk3 (or before the shell first renders the palette), Adwaita is used instead.

local color = require('modules.ui.color')

local M = {}

local SCHEME_KEY = "/org/gnome/desktop/interface/color-scheme"
local GTK_THEME_KEY = "/org/gnome/desktop/interface/gtk-theme"

local home = os.getenv("HOME") or ""
local config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local data_home = os.getenv("XDG_DATA_HOME") or (home .. "/.local/share")
local cache_home = os.getenv("XDG_CACHE_HOME") or (home .. "/.cache")
local themes_dir = data_home .. "/themes"
local template_dir = cache_home .. "/hypr/gtk"
local libadwaita_colors = config_home .. "/gtk-4.0/hypr-colors.css"
local LIBADWAITA_IMPORT = '@import url("hypr-colors.css");'

-- Single-mode imports the shells add to gtk.css, which pin apps to the mode they started in
local pinning_imports = { "dank%-colors%.css", "noctalia%.css", "hypr%-colors%.css" }

-- matugen syntax, rendered by both DMS (matugen) and Noctalia; MODE becomes light or dark. The
-- mapping follows the shells' own GTK templates.
local PALETTE = [[
@define-color accent_bg_color {{colors.primary.MODE.hex}};
@define-color accent_fg_color {{colors.on_primary.MODE.hex}};
@define-color destructive_bg_color {{colors.error.MODE.hex}};
@define-color destructive_fg_color {{colors.on_error.MODE.hex}};
@define-color error_bg_color {{colors.error.MODE.hex}};
@define-color error_fg_color {{colors.on_error.MODE.hex}};
@define-color window_bg_color {{colors.surface.MODE.hex}};
@define-color window_fg_color {{colors.on_surface.MODE.hex}};
@define-color view_bg_color {{colors.surface.MODE.hex}};
@define-color view_fg_color {{colors.on_surface.MODE.hex}};
@define-color headerbar_bg_color {{colors.surface.MODE.hex}};
@define-color headerbar_fg_color {{colors.on_surface.MODE.hex}};
@define-color headerbar_backdrop_color @window_bg_color;
@define-color sidebar_bg_color {{colors.surface_container.MODE.hex}};
@define-color sidebar_fg_color {{colors.on_surface.MODE.hex}};
@define-color sidebar_backdrop_color @sidebar_bg_color;
@define-color secondary_sidebar_bg_color {{colors.surface.MODE.hex}};
@define-color secondary_sidebar_fg_color {{colors.on_surface.MODE.hex}};
@define-color card_bg_color {{colors.surface_container.MODE.hex}};
@define-color card_fg_color {{colors.on_surface.MODE.hex}};
@define-color overview_bg_color {{colors.surface_container.MODE.hex}};
@define-color overview_fg_color {{colors.on_surface.MODE.hex}};
@define-color popover_bg_color {{colors.surface_container.MODE.hex}};
@define-color popover_fg_color {{colors.on_surface.MODE.hex}};
@define-color dialog_bg_color {{colors.surface.MODE.hex}};
@define-color dialog_fg_color {{colors.on_surface.MODE.hex}};
]]

-- GTK4 only (GTK3 can't parse it): adw-gtk3's GTK4 stylesheet takes the accent from the system
-- accent variables rather than the named colors
local ACCENT_VARS = [[
:root {
    --accent-bg-color: @accent_bg_color;
    --accent-fg-color: @accent_fg_color;
}
]]

local function shell_quote(s)
    return "'" .. s:gsub("'", "'\\''") .. "'"
end

local function read_file(path)
    local f = io.open(path, "r")
    if not f then
        return nil
    end
    local content = f:read("*a")
    f:close()
    return content
end

--- Skips identical writes, so file watchers in the shells don't reload for nothing
function M.write_if_changed(path, content)
    if read_file(path) == content then
        return
    end
    os.execute("mkdir -p " .. shell_quote(path:match("^(.*)/[^/]*$")))
    local f = io.open(path, "w")
    if f then
        f:write(content)
        f:close()
    end
end

---@return string|nil path <toolkit>/gtk.css of an installed theme. System copies come first, since
--- a user copy of adw-gtk3 may carry DMS's colors (its "Apply GTK colors" patches one).
local function find_theme_css(theme, toolkit)
    local dirs = {}
    for dir in (os.getenv("XDG_DATA_DIRS") or "/usr/share"):gmatch("[^:]+") do
        table.insert(dirs, dir .. "/themes")
    end
    table.insert(dirs, themes_dir)
    table.insert(dirs, home .. "/.themes")
    for _, dir in ipairs(dirs) do
        local path = dir .. "/" .. theme .. "/" .. toolkit .. "/gtk.css"
        if read_file(path) then
            return path
        end
    end
    return nil
end

-- Returns css with each `@media (prefers-color-scheme: X) { ... }` block unwrapped when X is
-- the given mode and removed otherwise. Combined queries are left alone.
local function resolve_color_scheme(css, mode)
    local out, pos = {}, 1
    while true do
        local s, e, query_mode = css:find("@media %(prefers%-color%-scheme: (%a+)%)%s*{", pos)
        if not s then
            break
        end
        -- Find the brace closing the block; GTK4 CSS has no nesting beyond rule blocks
        local depth, i, close = 1, e + 1, nil
        while depth > 0 do
            local b = css:find("[{}]", i)
            if not b then
                break
            end
            depth = depth + (css:sub(b, b) == "{" and 1 or -1)
            close, i = b, b + 1
        end
        if depth > 0 then
            break
        end
        table.insert(out, css:sub(pos, s - 1))
        if query_mode == mode then
            table.insert(out, css:sub(e + 1, close - 1))
        end
        pos = close + 1
    end
    table.insert(out, css:sub(pos))
    return table.concat(out)
end

-- GTK4 evaluates prefers-color-scheme inside a theme from the theme variant rather than the
-- system, so it stays light unless gtk-application-prefer-dark-theme is set (and selecting the
-- variant through a theme's settings.ini makes GTK reload in a loop). adw-gtk3's dark-mode rules,
-- like the brighter accent and destructive text, would then never apply as they do in libadwaita
-- apps. So each theme gets a copy of adw-gtk3's GTK4 stylesheet with the queries resolved for its
-- mode, and assets pointed back at adw-gtk3. The first line records the source, to skip rebuilds.
local function write_resolved_gtk4_base(base_css, path, dark)
    local base_dir = base_css:match("^(.*)/[^/]*$")
    local stamp = "/* Generated by Hyprland's customisations/gtk.lua from " .. base_dir .. " */\n"
    local current = read_file(path)
    if current and current:sub(1, #stamp) == stamp then
        return
    end

    local css = {}
    for _, file in ipairs({ "libadwaita.css", "libadwaita-tweaks.css" }) do
        table.insert(css, resolve_color_scheme(read_file(base_dir .. "/" .. file) or "", dark and "dark" or "light"))
    end
    local resolved = table.concat(css, "\n"):gsub('url%("assets/', 'url("file://' .. base_dir .. '/assets/')
    M.write_if_changed(path, stamp .. resolved)
end

local function srgb_to_linear(c)
    return c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
end

local function linear_to_srgb(c)
    c = math.min(math.max(c, 0), 1)
    return c <= 0.0031308 and 12.92 * c or 1.055 * c ^ (1 / 2.4) - 0.055
end

local function cbrt(x)
    return x < 0 and -((-x) ^ (1 / 3)) or x ^ (1 / 3)
end

--- libadwaita's standalone color, `oklab(from <hex> max(l, 0.85) a b)` in dark mode and
--- `min(l, 0.5)` in light mode (OKLab conversion from https://bottosson.github.io/posts/oklab/)
local function standalone_color(hex, dark)
    local r, g, b = hex:match("^#(%x%x)(%x%x)(%x%x)$")
    if not r then
        return nil
    end
    r, g, b = srgb_to_linear(tonumber(r, 16) / 255), srgb_to_linear(tonumber(g, 16) / 255), srgb_to_linear(tonumber(b, 16) / 255)

    local l_ = cbrt(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b)
    local m_ = cbrt(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b)
    local s_ = cbrt(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b)
    local L = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_
    local A = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_
    local B = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_

    L = dark and math.max(L, 0.85) or math.min(L, 0.5)

    local l = (L + 0.3963377774 * A + 0.2158037573 * B) ^ 3
    local m = (L - 0.1055613458 * A - 0.0638541728 * B) ^ 3
    local s = (L - 0.0894841775 * A - 1.2914855480 * B) ^ 3
    local channels = {
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    }
    for i, c in ipairs(channels) do
        channels[i] = math.floor(linear_to_srgb(c) * 255 + 0.5)
    end
    return ("#%02x%02x%02x"):format(channels[1], channels[2], channels[3])
end

-- adw-gtk3's GTK3 stylesheet approximates libadwaita where GTK3's CSS falls short: it derives the
-- standalone colors (accent text, focus rings, destructive text) by mixing with black or white,
-- as GTK3 has no oklab(), and lightens the suggested button and mixes the destructive one
-- differently. So the GTK3 themes get libadwaita's values computed from the palette, plus
-- libadwaita's rules for those two buttons.
local function libadwaita_compat_css(palette_css, dark)
    local lines = { "/* Generated by Hyprland's customisations/gtk.lua: libadwaita's look in GTK3 */" }
    for _, role in ipairs({ "accent", "destructive", "error" }) do
        local bg = palette_css:match("@define%-color " .. role .. "_bg_color (#%x+);")
        local color = bg and standalone_color(bg, dark)
        if color then
            table.insert(lines, "@define-color " .. role .. "_color " .. color .. ";")
        end
    end
    table.insert(lines, [[
button.suggested-action { background-color: @accent_bg_color; }
button.destructive-action { background-color: alpha(@destructive_color, 0.15); }]])
    return table.concat(lines, "\n") .. "\n"
end

local function palette(mode)
    return (PALETTE:gsub("MODE", mode))
end

local function write_templates()
    M.write_if_changed(template_dir .. "/palette-light.css", palette("light"))
    M.write_if_changed(template_dir .. "/palette-dark.css", palette("dark"))
    M.write_if_changed(template_dir .. "/libadwaita.css",
        "/* Generated by Hyprland's customisations/gtk.lua */\n" .. palette("light")
        .. "\n@media (prefers-color-scheme: dark) {\n" .. palette("dark") .. "}\n\n" .. ACCENT_VARS)
end

-- Rewrites gtk.css without the pinning imports, with `import` (if any) first as CSS requires
local function fix_gtk_css(path, import)
    local content = read_file(path)
    if not content then
        if import then
            M.write_if_changed(path, import .. "\n")
        end
        return
    end

    local kept = {}
    for line in (content .. "\n"):gmatch("([^\n]*)\n") do
        local pinning = false
        for _, pattern in ipairs(pinning_imports) do
            if line:match("^%s*@import.-" .. pattern) then
                pinning = true
                break
            end
        end
        if not pinning then
            table.insert(kept, line)
        end
    end
    while kept[1] == "" do
        table.remove(kept, 1)
    end
    if import then
        table.insert(kept, 1, import)
    end

    local new_content = (table.concat(kept, "\n"):gsub("\n+$", "")) .. "\n"
    if new_content ~= content then
        M.write_if_changed(path, new_content)
    end
end

--- Sets up live GTK theming for a shell.
---@param name string theme name, e.g. "DMS"; the themes are <name> and <name>-dark
---@return table shell with `templates` (id, input, output) for the shell to render and `sync()`
function M.setup(name)
    local variants = {
        { theme = name, base = "adw-gtk3", dark = false },
        { theme = name .. "-dark", base = "adw-gtk3-dark", dark = true },
    }

    local shell = {
        templates = {
            { id = "light", input = template_dir .. "/palette-light.css", output = themes_dir .. "/" .. name .. "/palette.css" },
            { id = "dark", input = template_dir .. "/palette-dark.css", output = themes_dir .. "/" .. name .. "-dark/palette.css" },
            { id = "libadwaita", input = template_dir .. "/libadwaita.css", output = libadwaita_colors },
        },
    }

    -- Themes are usable once adw-gtk3 is installed and the shell has rendered both palettes
    local function ensure_themes()
        local ready = true
        for _, v in ipairs(variants) do
            local dir = themes_dir .. "/" .. v.theme
            M.write_if_changed(dir .. "/index.theme",
                "[Desktop Entry]\nType=X-GNOME-Metatheme\nName=" .. v.theme .. "\n\n[X-GNOME-Metatheme]\nGtkTheme=" .. v.theme .. "\n")
            for _, toolkit in ipairs({ "gtk-3.0", "gtk-4.0" }) do
                local base_css = find_theme_css(v.base, toolkit)
                if base_css then
                    local css = '@import url("file://' .. base_css .. '");\n@import url("../palette.css");\n'
                    if toolkit == "gtk-3.0" then
                        local palette_css = read_file(dir .. "/palette.css")
                        if palette_css then
                            M.write_if_changed(dir .. "/gtk-3.0/libadwaita-compat.css", libadwaita_compat_css(palette_css, v.dark))
                            css = css .. '@import url("libadwaita-compat.css");\n'
                        end
                        M.write_if_changed(dir .. "/gtk-3.0/gtk.css", css)
                    else
                        write_resolved_gtk4_base(base_css, dir .. "/gtk-4.0/adw-gtk3.css", v.dark)
                        css = '@import url("adw-gtk3.css");\n@import url("../palette.css");\n' .. ACCENT_VARS
                        -- gtk-dark.css is what GTK loads when an app asks for the dark variant;
                        -- without it GTK would fall back to its built-in theme
                        for _, file in ipairs({ "gtk.css", "gtk-dark.css" }) do
                            M.write_if_changed(dir .. "/gtk-4.0/" .. file, css)
                        end
                    end
                else
                    ready = false
                end
            end
            ready = ready and read_file(dir .. "/palette.css") ~= nil
        end
        return ready
    end

    --- Points gtk-theme at the theme for the current scheme and keeps gtk.css free of pinning
    --- imports. Runs on every scheme change and from the shell's own hooks.
    function shell.sync()
        fix_gtk_css(config_home .. "/gtk-3.0/gtk.css", nil)
        fix_gtk_css(config_home .. "/gtk-4.0/gtk.css", read_file(libadwaita_colors) and LIBADWAITA_IMPORT or nil)

        local base = ensure_themes() and name or "Adwaita"
        local target = color.dconf_read(SCHEME_KEY) == "'prefer-dark'" and (base .. "-dark") or base
        if (color.dconf_read(GTK_THEME_KEY) or "") ~= "'" .. target .. "'" then
            color.dconf_write(GTK_THEME_KEY, "'" .. target .. "'")
        end
    end

    write_templates()
    color.on_scheme_change(function()
        shell.sync()
    end)

    return shell
end

--- For shells without GTK glue: moves gtk-theme off a theme generated above, which may have lost
--- its adw-gtk3 base (installed only for some shells) and would then render apps unstyled.
function M.reset()
    local theme = (color.dconf_read(GTK_THEME_KEY) or ""):gsub("^'(.*)'$", "%1")
    if theme == "" or not read_file(themes_dir .. "/" .. theme .. "/palette.css") then
        return
    end
    color.dconf_write(GTK_THEME_KEY, theme:match("%-dark$") and "'Adwaita-dark'" or "'Adwaita'")
end

return M
