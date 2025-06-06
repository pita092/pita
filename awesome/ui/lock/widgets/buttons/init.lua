local wibox          = require("wibox")
local awful          = require("awful")
local help           = require("core.help")
local beautiful      = require("beautiful")
local dpi            = beautiful.xresources.apply_dpi
local gears          = require("gears")
local config_dir     = gears.filesystem.get_configuration_dir()


local margin = 30

local button1 = wibox.widget({
  {
    {
      widget = wibox.widget.imagebox,
      image = config_dir .. "core/theme/icons/google/sun.svg",
      halign = 'center',
      valign = 'center',
      resize = true,
      clip_shape = help.rrect(),
    },
    widget = wibox.container.margin,
    margins = dpi(margin),
  },
  widget = wibox.container.background,
  bg = beautiful.bg_2,
  shape = help.rrect(),
  forced_width = 115,
  forced_height = 89,
})

local button2 = wibox.widget({
  {
    {
      widget = wibox.widget.imagebox,
      image = config_dir .. "core/theme/icons/google/headphones.svg",
      halign = 'center',
      valign = 'center',
      resize = true,
      clip_shape = help.rrect(),
    },
    widget = wibox.container.margin,
    margins = dpi(margin),
  },
  widget = wibox.container.background,
  bg = beautiful.bg_2,
  shape = help.rrect(),
  forced_width = 115,
  forced_height = 89,
})

local button3 = wibox.widget({
  {
    {
      widget = wibox.widget.imagebox,
      image = config_dir .. "core/theme/icons/google/dnd.svg",
      halign = 'center',
      valign = 'center',
      resize = true,
      clip_shape = help.rrect(),
    },
    widget = wibox.container.margin,
    margins = dpi(margin),
  },
  widget = wibox.container.background,
  bg = beautiful.bg_2,
  shape = help.rrect(),
  forced_width = 115,
  forced_height = 89,
})

local button4 = wibox.widget({
  {
    {
      widget = wibox.widget.imagebox,
      image = config_dir .. "core/theme/icons/google/wifi.svg",
      halign = 'center',
      valign = 'center',
      resize = true,
      clip_shape = help.rrect(),
    },
    widget = wibox.container.margin,
    margins = dpi(margin),
  },
  widget = wibox.container.background,
  bg = beautiful.bg_2,
  shape = help.rrect(),
  forced_width = 115,
  forced_height = 89,
})


help.addhover(button1, beautiful.bg_2, beautiful.blue)
help.addhover(button2, beautiful.bg_2, beautiful.green)
help.addhover(button3, beautiful.bg_2, beautiful.yellow)
help.addhover(button4, beautiful.bg_2, beautiful.red)
local widget = wibox.widget({
  {
    {
      {
        button1,
        spacing = dpi(7),
        layout = wibox.layout.fixed.horizontal,
      },
      {
        button2,
        spacing = dpi(7),
        layout = wibox.layout.fixed.horizontal,
      },
      {
        button3,
        spacing = dpi(7),
        layout = wibox.layout.fixed.horizontal,
      },
      {
        button4,
        spacing = dpi(7),
        layout = wibox.layout.fixed.horizontal,
      },
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(7),
    },
    widget = wibox.container.margin,
    margins = dpi(12)
  },
  shape = help.rrect(),
  widget = wibox.container.background,
  bg = beautiful.bg_1,
  forced_width = 125,
})
return widget
