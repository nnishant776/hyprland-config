-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local utils = require('utils')

local M = {}

--- @param o HyprlandConfig A table containing global hyprland configuration along with output configuration
function M.setup(o)
    local opts = o or {}

    ---@type HL.MonitorSpec
    local default_output_config = {
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = "1",
    }

    if not opts.screens then
        opts.screens = { default_output_config, }
    else
        table.insert(opts.screens or {}, 1, default_output_config)
    end

    ---@type table<string, HL.MonitorSpec>
    local seen = {}

    for _, cfg in ipairs(opts.screens) do
        if not seen[cfg.output] then
            seen[cfg.output] = cfg
        else
            seen[cfg.output] = utils.MergeDict(seen[cfg.output], cfg, 'force', true)
            cfg = seen[cfg.output]
        end
    end

    for _, cfg in pairs(seen) do
        hl.monitor(cfg)
    end
end

return M
