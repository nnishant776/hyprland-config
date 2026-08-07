local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        cursor = opts.ui.cursor,
    }

    hl.config(config)
end

return M
