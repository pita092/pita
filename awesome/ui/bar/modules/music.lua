local wibox      = require("wibox")
local awful      = require("awful")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local gears      = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
local help       = require("core.help")
local bling      = require("core.lib.bling")
local playerctl  = bling.signal.playerctl.lib({
  ignore = "firefox",
  player = { "mpd" }
})



local cover_art = wibox.widget {
  -- opacity = 0.3,
  forced_height = dpi(36),
  shape = help.rrect(5),
  forced_width = dpi(195),
  widget = wibox.widget.imagebox,
  image = help.cropSurface(4.6, gears.surface.load_uncached(config_dir .. "core/theme/icons/colored/nothing.png"))
}



local widget   = wibox.widget {
  {
    cover_art,
    {
      {
        widget = wibox.widget.textbox,
      },
      bg = {
        type = "linear",
        from = { 0, 0 },
        to = { 300, 0 },
        stops = { { 0, beautiful.bg_1 .. "88" }, { 1, beautiful.bg_1 } }
      },

      widget = wibox.container.background,
    },
    {
      {
        {
          align = 'center',
          font = beautiful.font_custom .. "22",
          markup = help.colortext('󱖑 ', beautiful.fg),
          widget = wibox.widget.textbox,
        },
        nil,
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin,
      left = 6,
    },
    layout = wibox.layout.stack,
  },
  widget = wibox.container.background,
  shape = help.rrect(5),
}

widget.buttons = gears.table.join(
  awful.button({}, 1, function()
    awesome.emit_signal("toggle::music")
  end)
)
playerctl:connect_signal("metadata",
  function(_, title, artist, album_path)
    cover_art:set_image(gears.surface.load_uncached(help.cropSurface(4.6, gears.surface.load_uncached(album_path))))
    awful.spawn.with_shell('st -e kitten icat' .. "album_path")
  end)


return widget
