local wibox          = require("wibox")
local awful          = require("awful")
local help           = require("core.help")
local beautiful      = require("beautiful")
local dpi            = beautiful.xresources.apply_dpi
local gears          = require("gears")
local config_dir     = gears.filesystem.get_configuration_dir()

local image = wibox.widget {
  widget = wibox.widget.imagebox,
  image = config_dir .. "core/theme/pfp/catpfp.png",
  resize = true,
  forced_height = dpi(160),
  forced_width = dpi(110),
}
image.shape = help.rrect()

return image
