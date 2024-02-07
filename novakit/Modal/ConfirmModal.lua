local path = (...):gsub('Modal.ConfirmModal', '')
local Panel = require(path .. '.Panel') ---@type fun(settings: NovaKIT.PanelSettings): NovaKIT.Panel
local VDiv = require(path .. 'VDiv') ---@type fun(settings: NovaKIT.ContainerSettings): NovaKIT.HDiv
local HDiv = require(path .. 'HDiv') ---@type fun(settings: NovaKIT.ContainerSettings): NovaKIT.VDiv
local Text = require(path .. 'Text') ---@type fun(settings: NovaKIT.TextSettings|string): NovaKIT.Text
local Button = require(path .. 'Button') ---@type fun(settings: NovaKIT.ButtonSettings): NovaKIT.Button

---@class NovaKIT.Modal.ConfirmModalSettings
---@field title string
---@field yes function
---@field no function

---@param settings NovaKIT.Modal.ConfirmModalSettings
return function(settings)
    return Panel {
        root = VDiv {
            width = 400,
            height = 300,
            children = {
                Text(settings.title),
                HDiv {
                    children = {
                        Button {
                            text = 'Yes',
                        }, -- Button
                        Button {
                            text = 'No',
                        } -- Button
                    }
                }         -- HDiv
            }
        }                 -- VDiv
    }                     -- Panel

    -- local ConfirmModal = Panel {
    --     root = VDiv {
    --         width = 400,
    --         height = 300,
    --         alignmentMethod = 'position'
    --     }
    -- }

    -- -- Title

    -- ConfirmModal:addImmutable(Text {
    --     text = settings.title,
    --     height = 250
    -- })

    -- -- HDiv

    -- local hdiv = ConfirmModal:addImmutable(HDiv {
    --     height = 50
    -- }) ---@cast hdiv HDiv

    -- local yes = hdiv:addImmutable(Button 'Yes')
    -- yes:addEventListener('onClick', function() settings.yes() end)

    -- local no = hdiv:addImmutable(Button 'No')
    -- no:addEventListener('onRelease', function() settings.no() end)

    -- return ConfirmModal
end
