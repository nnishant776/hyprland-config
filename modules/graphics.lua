local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        general = {
            allow_tearing = opts.graphics.allow_tearing,
        }
    }

    hl.config(config)
end

return M
