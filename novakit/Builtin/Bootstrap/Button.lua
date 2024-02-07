local path = (...):gsub('Builtin.Bootstrap.Button', '')
local novakit = require(path .. '.init') ---@type NovaKIT
local override = novakit.override
local rgb = novakit.rgb

local inter = {
  color = rgb(248, 249, 250),
  font = novakit.Font.Inter.Regular(14)
}

---Creates a base button for every boostrap themed buttons
---@param settings NovaKIT.ButtonSettings
return function(settings)
  return novakit.Button(override(settings, {
    style = {
      default = {
        stylebox = {
          color = rgb(13, 110, 253)
        },
        textstyle = inter
      },
      hovered = {
        stylebox = {
          color = rgb(11, 94, 215)
        },
        textstyle = inter
      },
      clicked = {
        stylebox = {
          color = rgb(10, 92, 210)
        },
        textstyle = inter
      }
    }
  }))
end
