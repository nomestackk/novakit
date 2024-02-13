---@alias NovaKIT.ColorFormat { [1]: integer, [2]: integer, [3]: integer, [4]: integer }

-- Component

---@class NovaKIT.ComponentSettings
---@field name? string
---@field cursor? love.CursorType
---@field x? number
---@field y? number
---@field width? number
---@field height? number
---@field rotation? integer
---@field events? table<NovaKIT.ComponentEventName,function[]> Represents a queue list of callbacks.
---@field mouseListener? 1|2|3 Determines which mouse button will be heard when clicks are calculated.
---@field parent? NovaKIT.Container Components may have a Container as its parent. If it has this field represents the parent.
---@field display? boolean Determines whether this component is going to be rendered or not.
---@field enabled? boolean Determines whether this component is going to execute other events (except 'draw').
---@field antiAlign? boolean
---@field onenter? fun(self, ...)
---@field onleave? fun(self, ...)
---@field onclick? fun(self, ...)
---@field onrelease? fun(self, ...)
---@field draw? fun(self, ...)

---@alias NovaKIT.ComponentEventName
---| 'onClick'
---| 'onRelease'
---| 'onEnter'
---| 'onLeave'
---| 'draw'
---| string

-- Container --

---@class NovaKIT.ContainerSettings: NovaKIT.ComponentSettings
---@field gap? integer Determines how many gap this component will have.
---@field alignmentMethod? 'position+size'|'position'|'size' Determines how this component will align its children.
---@field children? NovaKIT.Component[] Determines the list of children of this component.
---@field alignOnMutation? boolean Determines whether this container should be align when `x`, `y`, `width` and `height` properties are changed.
---@field fixedSize? boolean

-- Button --

---@class NovaKIT.ButtonStyle
---@field stylebox? NovaKIT.Stylebox
---@field textstyle? NovaKIT.TextStyle

---@class NovaKIT.ButtonSettings: NovaKIT.ComponentSettings
---@field text? string Represents the text content of this Button.
---@field stylebox? NovaKIT.Stylebox Represents the Stylebox that will be rendered behind the text.
---@field textstyle? NovaKIT.TextStyle Represents the TextStyle that will be rendered on top of the background.
---@field hovered? NovaKIT.ButtonStyle
---@field clicked? NovaKIT.ButtonStyle
---@field animationSpeed? number
