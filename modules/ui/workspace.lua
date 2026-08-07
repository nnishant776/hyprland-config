local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}

    for _, rule in ipairs(opts.ui.workspace.rules or {}) do
        hl.workspace_rule(rule)
    end
end

return M
