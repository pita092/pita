local wibox          = require("wibox")
local awful          = require("awful")
local help           = require("core.help")
local beautiful      = require("beautiful")
local dpi            = beautiful.xresources.apply_dpi
local gears          = require("gears")
local config_dir     = gears.filesystem.get_configuration_dir()

-- widget = wibox.container.margin,

local profile = wibox.widget({
  {
    {
      {
        require("ui.lock.widgets.prof.image"),
        require("ui.lock.widgets.prof.name"),
        require("ui.lock.widgets.sound"),
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(12),
      },
      widget = wibox.container.margin,
      margins = dpi(12)
    },
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(12)
  },
  widget = wibox.container.background,
  bg = beautiful.bg_1,
  forced_width = 600,
  forced_height = 150,
  -- shape = function(cr, width, height)
  --   gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 15)
  -- end,
  shape = help.rrect()
})

return profile
