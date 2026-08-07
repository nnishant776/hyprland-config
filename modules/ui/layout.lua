local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        general = {
            layout = opts.ui.layout.name,
        },
        scrolling = opts.ui.layout.scrolling or {},
        master = opts.ui.layout.master or {},
        dwindle = opts.ui.layout.dwindle or {},
    }

    hl.config(config)
end

return M
