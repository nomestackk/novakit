local path = (...):gsub('VDiv', '')
local VDiv = require(path .. '.VDiv')

---@param root? NovaKIT.Container
return function(root)
    ---@class Page: NovaKIT.Container
    local Page = root or VDiv()

    Page.name = 'Page'
    Page.root = Page

    return Page
end
