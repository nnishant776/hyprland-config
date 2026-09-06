local utils = require('utils')

local M = {
    MainMod = "SUPER"
}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}

    ---@type KeybindSpec[]
    local default_key_binds = {
        { key = M.MainMod .. "+ SHIFT + R", dispatcher = hl.dsp.exec_cmd("hyprctl reload"), options = {} },
    }

    ---@type KeybindSpec[]
    local final_keybinds = utils.MergeList(default_key_binds, opts.keybinds, function(e) return e.key end)

    for _, bindCfg in ipairs(final_keybinds) do
        hl.bind(bindCfg.key, bindCfg.dispatcher, bindCfg.options)
        if bindCfg.submaps then
            hl.define_submap(bindCfg.submapKey, function()
                for _, submapCfg in ipairs(bindCfg.submaps) do
                    hl.bind(submapCfg.key, submapCfg.dispatcher, submapCfg.options)
                end
            end)
        else

        end
    end

    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(M.MainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
        hl.bind(M.MainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
    end

    hl.bind(M.MainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
    hl.bind(M.MainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

    -- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
    -- hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(cfg.programs.Terminal))
    -- local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
    -- -- closeWindowBind:set_enabled(false)
    -- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
    -- hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(cfg.programs.FileManager))
    -- hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
    -- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(cfg.programs.Menu))
    -- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
    -- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

    -- -- Move focus with mainMod + arrow keys
    -- hl.bind(mainMod .. " + h",  hl.dsp.focus({ direction = "left" }))
    -- hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
    -- hl.bind(mainMod .. " + k",    hl.dsp.focus({ direction = "up" }))
    -- hl.bind(mainMod .. " + j",  hl.dsp.focus({ direction = "down" }))
end

return M
