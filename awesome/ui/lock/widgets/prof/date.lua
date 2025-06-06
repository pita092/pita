local wibox          = require("wibox")
local awful          = require("awful")
local help           = require("core.help")
local beautiful      = require("beautiful")
local dpi            = beautiful.xresources.apply_dpi
local gears          = require("gears")
local config_dir     = gears.filesystem.get_configuration_dir()

local function format_date()
  return os.date("%A, %B %d")
end

-- Date widget
local date_widget = wibox.widget {
  markup = "<span font='14' color='#FFFFFF'>" .. format_date() .. "</span>",
  widget = wibox.widget.textbox,
}

-- Update date every minute
gears.timer {
  timeout = 60,
  call_now = true,
  autostart = true,
  callback = function()
    date_widget.markup = "<span font='14' color='#FFFFFF'>" .. format_date() .. "</span>"
  end
}

return date_widget
