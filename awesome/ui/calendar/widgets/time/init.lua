local wibox      = require("wibox")
local awful      = require("awful")
local help       = require("core.help")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local gears      = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
local function get_uptime_cmd()
  local handle = io.popen("uptime -p")
  local result = handle:read("*a")
  handle:close()

  -- remove "up " and newline
  result = result:gsub("^up%s+", ""):gsub("\n", "")

  -- replace "hour(s)" and "minute(s)" with "H" and "M"
  result = result
      :gsub(" hours?", "h")
      :gsub(" minutes?", "m")
      :gsub(",", "")    -- remove comma
      :gsub("%s+", " ") -- normalize spaces

  return result
end


local time = wibox.widget {
  format = help.colortext('%H:%M', beautiful.fg .. '88'),
  widget = wibox.widget.textclock,
  font = beautiful.font_custom .. '40',
}
local uptime = wibox.widget {
  widget = wibox.widget.textbox,
  markup = "",
  font = beautiful.font_custom .. '18',
}
local datetime = wibox.widget {
  {
    {
      time,
      {
        uptime,
        align = "center",
        widget = wibox.container.place,
      },
      layout = wibox.layout.align.vertical,
    },
    align = "center",
    widget = wibox.container.place,
  },
  widget = wibox.container.background,
  bg = beautiful.bg_1,
  forced_height = 100
}
local widget = wibox.widget {

  {
    nil,
    datetime,
    layout = wibox.layout.align.horizontal,
  },
  shape = help.rrect(),
  widget = wibox.container.background,
  bg = beautiful.bg_1,
}

gears.timer {
  timeout   = 60,
  call_now  = true,
  autostart = true,
  callback  = function()
    time.format = help.colortext(' %H:%M ', beautiful.fg .. '99')
    uptime.markup = get_uptime_cmd()
  end
}


return widget
