local wibox      = require("wibox")
local awful      = require("awful")
local help       = require("core.help")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local gears      = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()


local lock_wibox = wibox({
  screen = awful.screen.focused(),
  visible = false,
  ontop = true,
  type = "dock",
  height = 665,
  width = dpi(600),
  shape = help.rrect()
})


lock_wibox:setup {
  {
    {
      {
        {
          require("ui.lock.widgets.title"),
          widget = wibox.container.margin,
          margins = {
            left = -12,
            right = -12,
            top = -12,
            bottom = 4,
          }
        },
        spacing = dpi(7),
        {
          {
            {
              require("ui.lock.widgets.prof"),
              layout = wibox.layout.fixed.horizontal,
              spacing = dpi(7),
            },
            {
              {
                require("ui.lock.widgets.sys"),
                layout = wibox.layout.fixed.vertical,
              },
              layout = wibox.layout.fixed.horizontal,
              spacing = dpi(7),
              require("ui.lock.widgets.buttons"),
            },
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(7),
          },
          layout = wibox.layout.fixed.horizontal,
        },
        require("ui.lock.widgets.sliders"),
        layout = wibox.layout.fixed.vertical,
      },
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = dpi(12)
  },
  widget = wibox.container.background,
  bg = beautiful.bg_2,
  shape = help.rrect(),
}

return {
  wibox = lock_wibox
}
