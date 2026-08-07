local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        general = {
            gaps_in = opts.ui.window.border.gaps_in,
            gaps_out = opts.ui.window.border.gaps_out,
            border_size = opts.ui.window.border.border_size,
            resize_on_border = opts.ui.window.border.resize_on_border,
            col = opts.ui.window.border.color,
            snap = opts.ui.window.snapping,
            no_focus_fallback = opts.ui.window.focus.no_focus_fallback,
        }
    }

    hl.config(config)

    for _, rule in ipairs(opts.ui.window.rules or {}) do
        hl.window_rule(rule)
    end
end

return M
