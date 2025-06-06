local wibox     = require("wibox")
local help      = require("core.help")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local gears     = require("gears")


local my_time = wibox.widget {
  format = help.colortext(' %H:%M ', beautiful.fg .. '88'),
  widget = wibox.widget.textclock,
  font = beautiful.icon,
}
local my_date = wibox.widget {
  format = help.colortext('%B %d ', beautiful.fg .. '88'),
  widget = wibox.widget.textclock,
  font = beautiful.font,
}


local thing = wibox.widget
    {

      {
        {
          my_time,
          my_date,
          widget = wibox.container.margin,
          layout = wibox.layout.fixed.horizontal,
          margins = dpi(5),
        },
        widget = wibox.container.margin,
        margins = dpi(8),
      },
      shape = help.rrect(),
      widget = wibox.container.background,
      bg = beautiful.bg_1,
    }

thing.buttons = gears.table.join(
  awful.button({}, 1, function()
    awesome.emit_signal("toggle::calendar")
  end)
)
help.addhover(thing, beautiful.bg_1, beautiful.blue .. '44')


gears.timer {
  timeout   = 60,
  call_now  = true,
  autostart = true,
  callback  = function()
    my_time.format = help.colortext(' %H:%M ', beautiful.fg .. '88')
    my_date.format = help.colortext('%B %d ', beautiful.fg .. '88')
  end
}

return thing
