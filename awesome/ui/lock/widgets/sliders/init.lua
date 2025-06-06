local wibox      = require("wibox")
local awful      = require("awful")
local help       = require("core.help")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local gears      = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()


local Slider = function(icon, signal, command)
  local slider = wibox.widget {
    bar_shape           = help.rrect(),
    bar_height          = 5,
    handle_color        = beautiful.bg_2,
    bar_color           = beautiful.blue .. '55',
    bar_active_color    = beautiful.blue,
    handle_shape        = function(cr)
      return gears.shape.partially_rounded_rect(cr, 20, 20, true, true, true, true, 2000)
    end,
    handle_border_color = beautiful.blue,
    handle_border_width = 2,
    handle_margins      = { top = dpi(8) },
    forced_height       = 35,
    maximum             = 200,
    widget              = wibox.widget.slider,
    value               = 75,
  }
  local sliderIcon = wibox.widget {
    {
      font = beautiful.font_custom .. "18",
      markup = help.colortext(icon, beautiful.fg),
      valign = "center",
      widget = wibox.widget.textbox,
    },
    widget = wibox.container.margin,
  }

  local sliderReturn = wibox.widget {
    {
      {
        sliderIcon,
        {
          slider,
          layout = wibox.layout.stack,
        },
        layout = wibox.layout.fixed.horizontal,
        spacing = 8
      },
      widget = wibox.container.margin,
      left = dpi(10),
      right = dpi(5),
    },
    widget = wibox.container.background,
    bg = beautiful.bg_1,
  }

  awesome.connect_signal('signal::' .. signal, function(value)
    slider.value = value
  end)
  slider:connect_signal("property::value", function(_, new_value)
    awful.spawn.with_shell(string.format(command, new_value))
  end)
  return sliderReturn
end

local widget = wibox.widget {
  Slider("󱄠 ", "volume", "pamixer --set-volume %d"),
  layout = wibox.layout.fixed.vertical,
  spacing = 0,
}

return widget
