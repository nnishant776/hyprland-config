local utils = require('utils')

local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        animations = {
            enabled = opts.ui.animation.enable,
        }
    }

    hl.config(config)

    for k, v in pairs(opts.ui.animation.curves) do
        hl.curve(k, v)
    end

    for _, v in ipairs(opts.ui.animation.rules) do
        hl.animation(v)
    end
end

return M
