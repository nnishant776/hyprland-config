local M = {}

---@param input any[]
---@param filter function(input: any): any
---@return table
function M.FilterUnique(input, filter)
    local seen = {}
    local final_list = {}
    input = input or {}
    for _, value in ipairs(input) do
        local isSeen = false
        if filter then
            isSeen = seen[filter(value)]
        else
            isSeen = seen[value]
        end
        if not isSeen then
            table.insert(final_list, value)
        end
    end
    return final_list
end

---@param t1 table
---@param t2 table
---@param filter function(input: any): any
---@return table
function M.MergeList(t1, t2, filter)
    local list1 = M.FilterUnique(t1, filter)
    local list2 = M.FilterUnique(t2, filter)
    local final_list = {}

    for _, value in ipairs(list1) do
        table.insert(final_list, value)
    end
    for _, value in ipairs(list2) do
        table.insert(final_list, value)
    end

    return final_list
end

function M.DeepCopy(t)
    if type(t) ~= "table" then
        return t
    end
    local copy = {}
    for k, v in pairs(t) do
        copy[M.DeepCopy(k)] = M.DeepCopy(v)
    end
    return copy
end

---@param d1 table
---@param d2 table
---@param behaviour 'keep'|'force'
---@param deepcopy boolean
---@return table
function M.MergeDict(d1, d2, behaviour, deepcopy)
    local result = {}
    d1 = d1 or {}
    d2 = d2 or {}

    -- Pre-populate the result table with a deep copy of d1
    for k, v in pairs(d1) do
        if deepcopy then
            result[k] = M.DeepCopy(v)
        else
            result[k] = v
        end
    end

    -- Merge keys from d2
    for k, v in pairs(d2) do
        if result[k] == nil then
            if deepcopy then
                result[k] = M.DeepCopy(v)
            else
                result[k] = v
            end
        else
            local v1 = result[k]
            local v2 = v
            if type(v1) == "table" and type(v2) == "table" then
                -- Both are tables; recursively merge them
                result[k] = M.MergeDict(v1, v2, behaviour, deepcopy)
            else
                -- Conflict: at least one is not a table. Use 'behaviour' to resolve
                if behaviour == "force" then
                    if deepcopy then
                        result[k] = M.DeepCopy(v2)
                    else
                        result[k] = v2
                    end
                end
                -- If behaviour is 'keep', we keep v1 (which is already in result[k])
            end
        end
    end

    return result
end

return M
