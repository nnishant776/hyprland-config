local utils = require('utils')

local M = {}

local function table_to_json(tbl)
    local result = {}
    local is_array = #tbl > 0 -- Simple check to see if it's an array

    if is_array then
        for _, val in ipairs(tbl) do
            if type(val) == "table" then
                table.insert(result, table_to_json(val))
            elseif type(val) == "string" then
                table.insert(result, string.format('"%s"', val))
            else
                table.insert(result, tostring(val))
            end
        end
        return "[" .. table.concat(result, ",") .. "]"
    else
        for key, val in pairs(tbl) do
            local key_str = string.format('"%s"', tostring(key))
            if type(val) == "table" then
                table.insert(result, string.format('%s:%s', key_str, table_to_json(val)))
            elseif type(val) == "string" then
                table.insert(result, string.format('%s:"%s"', key_str, val))
            else
                table.insert(result, string.format('%s:%s', key_str, tostring(val)))
            end
        end
        return "{" .. table.concat(result, ",") .. "}"
    end
end

---@param o HyprlandConfig
function M.setup(o)
    local opts = o or {}
    local config = {
        animations = {
            enabled = opts.ui.animation.enable,
        }
    }

    hl.config(config)

    for _, v in ipairs(opts.ui.animation.rules) do
        print(table_to_json(v))
        hl.animation(v)
    end

    for k, v in pairs(opts.ui.animation.curves) do
        hl.curve(k, v)
    end
end

return M
