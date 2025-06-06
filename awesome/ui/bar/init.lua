local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi   = beautiful.xresources.apply_dpi
local help = require("core.help")


awful.screen.connect_for_each_screen(function(s)
  awful.tag({ " ", " ", " ", " ", " " }, s, awful.layout.layouts[1])

  local separator = wibox.widget {
    {
      widget = wibox.widget.separator,
      orientation = "horizontal",
      forced_height = dpi(2),
      color = beautiful.bg_2,
    },
    widget = wibox.container.place,
    valign = "center",
    content_fill_horizontal = true,
  }
  local bar = wibox.widget {
    {
      {
        {
          require("ui.bar.modules.actions"),
          {
            {
              {
                require("ui.bar.modules.taglist").create_taglist(s),
                layout = wibox.layout.fixed.horizontal,
              },
              widget = wibox.container.margin,
              margins = dpi(8),
            },
            shape = help.rrect(),
            widget = wibox.container.background,
            bg = beautiful.bg_1,
            forced_width = 256
          },
          require("ui.bar.modules.music"),
          -- require("ui.bar.modules.actions"),
          require("ui.bar.modules.personal"),
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(8)
        },
        layout = wibox.layout.align.horizontal,
        spacing = dpi(7)
      },
      widget = wibox.container.margin,
      margins = dpi(8),
    },
    widget = wibox.container.background,
    bg = beautiful.bg,
    shape = help.rrect()
  }

  s.bar = awful.wibar({
    position = "top",
    screen   = s,
    width    = s.geometry.width,
    height   = dpi(70),
    bg       = "#00000000",
    fg       = beautiful.fg,
    widget   = {
      {
        bar,
        {
          {
            require("ui.bar.modules.clock"),
            widget = wibox.container.margin,
            margins = dpi(8),
          },
          widget = wibox.container.background,
          bg = beautiful.bg,
          shape = help.rrect()
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(12)

      },
      widget = wibox.container.margin,
      left = 10,
      top = 8,
    },
  })
end)
