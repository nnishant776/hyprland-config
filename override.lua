pcall(require, 'monitors')

local cfg = require("config")

if cfg.ui.customShells.variant == 'dms' then
    pcall(require, 'customisations.dms')
elseif cfg.ui.customShells.variant == 'noctalia' then
    pcall(require, 'customisations.noctalia')
else
    require('customisations.gtk').reset()
end
