local novakit = require 'novakit'
local rgb = novakit.rgb

local root = novakit.Container()

local font = love.graphics.newFont('fonts/inter/Regular.ttf', 14)
font:setFilter("nearest", "nearest")

local white = novakit.TextStyle {
  font = font,
  color = { 1, 1, 1, 1 }
}

local black = novakit.TextStyle {
  font = font,
  color = { 0, 0, 0, 1 }
}

local modal = root:addImmutable(novakit.Panel {
  root = novakit.VDiv {
    width = 400,
    height = 300,
  },
  stylebox = novakit.Stylebox {
    shrink = -16,
    color = { 1, 1, 1, 1 },
    radius = 16
  }
}) ---@cast modal NovaKIT.VDiv

local text = modal:addImmutable(novakit.Text {
  text = 'Modal Text',
  height = 200,
  textStyle = black
}) ---@cast text NovaKIT.Text
local hdiv = modal:addImmutable(novakit.HDiv { height = 100 }) ---@cast hdiv NovaKIT.HDiv
local ok = modal:addImmutable(novakit.Button {
  text = 'Ok',
  width = 100,
  stylebox = novakit.Stylebox {
    color = rgb(3, 218, 198),
  },
  hovered = {
    stylebox = novakit.Stylebox {
      color = rgb(1, 135, 134),
      radius = 8
    }
  },
  textstyle = white
}) ---@cast ok NovaKIT.Button
local cancel = modal:addImmutable(novakit.Button {
  text = 'Cancel',
  width = 100,
  stylebox = novakit.Stylebox {
    color = rgb(176, 0, 32)
  },
  hovered = {
    stylebox = novakit.Stylebox {
      color = rgb(157, 0, 24),
      radius = 8
    }
  },
  textstyle = white
}) ---@cast cancel NovaKIT.Button

modal:center()
modal:middle()
modal:align()

function love.draw()
  root:draw()
end
