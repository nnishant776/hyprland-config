local utils = require('utils')

local M = { }

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        input = {
            touchpad = opts.input.pointingDevice.touchpad,
        },
    }

    config.input = utils.MergeDict(config.input, opts.input.keyboardDevice, "force", false)
    config.input = utils.MergeDict(config.input, opts.input.pointingDevice.mouse, "force", false)

    hl.config(config)

    -- Setup gestures
    for _, gesture in ipairs(opts.input.pointingDevice.gestures) do
        hl.gesture(gesture)
    end
end

return M
