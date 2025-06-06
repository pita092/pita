local wibox      = require("wibox")
local awful      = require("awful")
local help       = require("core.help")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local gears      = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()


local M = {}
M.control_c = wibox({
  shape = help.rrect(),
  width = dpi(600),
  height = 650,
  bg = beautiful.bg_2,
  fg = beautiful.fg,
  border_width = 0,
  border_color = beautiful.fg,
  margins = 20,
  ontop = true,
  visible = false,
  x = dpi(1704),
  y = dpi(0),
})


M.control_c:setup {
  {
    {
      {
        {
          require("ui.calendar.widgets.title"),
          widget = wibox.container.margin,
          margins = {
            left = -12,
            right = -12,
            top = -12,
            bottom = 4
          }
        },

        require("ui.calendar.widgets.time"),
        require("ui.calendar.widgets.cal")(),
        {
          require("ui.calendar.widgets.weather").text,
          require("ui.calendar.widgets.weather").photo,
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(7),
        },
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(7),
      },
      layout = wibox.layout.fixed.vertical,
      widget = wibox.container.place,
    },
    widget = wibox.container.margin,
    margins = dpi(12)
  },
  layout = wibox.layout.fixed.vertical,
}

return M
