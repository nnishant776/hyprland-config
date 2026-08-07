local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        misc = opts.ui.misc,
    }

    hl.config(config)
end

return M
