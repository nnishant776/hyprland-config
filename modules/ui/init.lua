local M = {}

function M.setup(o)
    require('modules.ui.color').setup(o)
    require('modules.ui.layout').setup(o)
    require('modules.ui.window').setup(o)
    require('modules.ui.cursor').setup(o)
    require('modules.ui.decorations').setup(o)
    require('modules.ui.animations').setup(o)
    require('modules.ui.misc').setup(o)
    require('modules.ui.workspace').setup(o)
end

return M
