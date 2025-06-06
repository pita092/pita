local wibox = require("wibox")
local beautiful = require("beautiful")
local help = require("core.help")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi



local M = {}
M.control_c = wibox({
  shape = help.rrect(),
  width = dpi(600),
  height = 282,
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
        require("ui.music.title"),
        widget = wibox.container.margin,
        margins = {
          left = -12,
          right = -12,
          top = -12,
          bottom = 4,
        }
      },
      {
        require("ui.music.sound"),
        layout = wibox.layout.fixed.vertical,
      },
      layout = wibox.layout.fixed.vertical,
      widget = wibox.container.place,
      spacing = dpi(7),
    },
    widget = wibox.container.margin,
    margins = dpi(12)
  },
  layout = wibox.layout.fixed.vertical,
}

return M
