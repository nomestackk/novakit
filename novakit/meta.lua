---@alias NovaKIT.ColorFormat { [1]: integer, [2]: integer, [3]: integer, [4]: integer }

---@class NovaKIT.ContainerSettings: NovaKIT.ComponentSettings
---@field gap? integer Determines how many gap this component will have.
---@field alignmentMethod? 'position+size'|'position'|'size' Determines how this component will align its children.
---@field children? NovaKIT.Component[] Determines the list of children of this component.
---@field alignOnMutation? boolean Determines whether this container should be align when `x`, `y`, `width` and `height` properties are changed.
