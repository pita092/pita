local wibox      = require("wibox")
local awful      = require("awful")
local help       = require("core.help")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local gears      = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()


local picture = wibox.widget({
  widget                = wibox.widget.imagebox,
  image                 = config_dir .. "core/theme/pfp/catpfp.png",
  halign                = 'center',
  valign                = 'center',
  resize                = true,
  clip_shape            = help.rrect(),
  vertical_fit_policy   = 'fit',
  horizontal_fit_policy = 'fit'
})



local widget = wibox.widget({
  {
    require("ui.bar.modules.weather").widget,
    {
      picture,
      widget = wibox.container.margin,
      margins = dpi(5)
    },
    layout = wibox.layout.align.horizontal,
  },
  widget = wibox.container.background,
  bg = beautiful.bg_1,
  shape = help.rrect(),
  forced_width = 145,
})


picture.buttons = gears.table.join(
  awful.button({}, 1, function()
    awesome.emit_signal("toggle::lock")
  end)
)


return widget
