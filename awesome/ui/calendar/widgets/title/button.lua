local wibox      = require("wibox")
local awful      = require("awful")
local help       = require("core.help")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local gears      = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()



local button = wibox.widget {
  {
    widget = wibox.widget.textbox,
    text = " ",
    font = beautiful.icon
  },
  widget = wibox.container.margin,
  margins = dpi(0),
}



button:buttons {
  awful.button({}, 1, function()
    awesome.emit_signal("toggle::dashboard")
  end),
}

help.addhover(button, beautiful.blue, beautiful.blue)


return button
