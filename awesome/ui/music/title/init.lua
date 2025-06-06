local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
local dpi = beautiful.xresources.apply_dpi

local help = require("core.help")


local widget = wibox.widget {
  {
    nil,
    {
      {
        {
          widget = wibox.widget.textbox,
          markup = " music",
          align = "left",
        },
        margins = dpi(7),
        widget = wibox.container.margin
      },
      widget = wibox.container.background,
      bg = beautiful.bg_1,
      shape = help.rrect(),
      forced_width = 38
    },
    layout = wibox.layout.align.horizontal
  },
  widget = wibox.container.background,
  bg = beautiful.bg_1,
  forced_height = 50,
  shape = help.rrect(),
}

return widget
