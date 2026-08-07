local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        decoration = opts.ui.decoration,
    }

    hl.config(config)
end

return M
