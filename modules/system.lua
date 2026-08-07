local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        general = {
            locale = opts.system.locale,
        }
    }

    hl.config(config)
end

return M
