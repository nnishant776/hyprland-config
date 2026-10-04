local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        general = {
            allow_tearing = opts.graphics.allow_tearing,
        },
        misc = {
            vrr = opts.graphics.vrr,
        },
        xwayland = {
            force_zero_scaling = opts.graphics.force_zero_scaling
        }
    }

    hl.config(config)
end

return M
