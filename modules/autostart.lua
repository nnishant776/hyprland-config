local M = {}

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    hl.on("hyprland.start", function()
        for _, cmd in ipairs(opts.autostart) do
            hl.exec_cmd(cmd)
        end
    end)
end

return M
