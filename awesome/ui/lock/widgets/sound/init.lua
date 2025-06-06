local wibox          = require("wibox")
local awful          = require("awful")
local help           = require("core.help")
local beautiful      = require("beautiful")
local dpi            = beautiful.xresources.apply_dpi
local gears          = require("gears")
local config_dir     = gears.filesystem.get_configuration_dir()
local bling = require("core.lib.bling")
local playerctl = bling.signal.playerctl.lib({

      ignore = "firefox",
    player = {"mpd", "%any"}
})



local cover_art   = wibox.widget({
  clip_shape = help.rrect(),
  resize = true,
  widget = wibox.widget.imagebox,
  image = help.cropSurface(1.4, gears.surface.load_uncached(config_dir .. "core/theme/icons/colored/nothing.png")),
})
local song_text   = wibox.widget {
  text   = "nothing is playing",
  font   = beautiful.font_custom .. "15",
  widget = wibox.widget.textbox
}

local artist_text = wibox.widget {
  text   = "none",
  font   = beautiful.font_custom .. "10",
  widget = wibox.widget.textbox
}



local spotify_widget = wibox.widget {
  {
    cover_art,
    {
      {
        widget = wibox.widget.textbox,
      },
      bg = {
        type = "linear",
        from = { 0, 0 },
        to = { 250, 0 },
        stops = { { 0, beautiful.bg .. "99" }, { 1, beautiful.bg_1 } }
      },

      widget = wibox.container.background,
    },
    {
      {
        {
          song_text,
          artist_text,
          {
            {
              markup = help.colortext('󱖑 ', beautiful.fg),
              font = beautiful.font_custom .. "25",
              widget = wibox.widget.textbox
            },
            widget = wibox.container.margin,
            top = dpi(55)
          },
          layout = wibox.layout.align.vertical,
        },
        widget = wibox.container.margin,
        top = dpi(4),
        left = dpi(6)
      },
      layout = wibox.layout.align.vertical,
    },
    layout = wibox.layout.stack,
  },
  layout = wibox.layout.align.vertical,
}

local playerctl      = bling.signal.playerctl.lib()
playerctl:connect_signal("metadata",
  function(_, title, artist, album_path)
    cover_art:set_image(gears.surface.load_uncached(help.cropSurface(1.4,
      gears.surface.load_uncached(album_path and album_path or beautiful.nosongpic))))
    song_text:set_markup_silently("<b>" .. title .. "</b>")
    artist_text:set_markup_silently(artist)
  end)



return spotify_widget
