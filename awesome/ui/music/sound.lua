local gears      = require("gears")
local beautiful  = require("beautiful")
local wibox      = require("wibox")
local bling      = require("core.lib.bling")
local playerctl  = bling.signal.playerctl.lib({
  ignore = "firefox",
  player = { "mpd", "%any" }
})
local help       = require("core.help")
local config_dir = gears.filesystem.get_configuration_dir()
local awful      = require("awful")
local dpi        = beautiful.xresources.apply_dpi



local cover_art   = wibox.widget({
  clip_shape = help.rrect(),
  resize = true,
  widget = wibox.widget.imagebox,
  image = help.cropSurface(2.19, gears.surface.load_uncached(config_dir .. "core/theme/icons/colored/nothing.png"))
})
local song_text   = wibox.widget {
  text   = "",
  font   = beautiful.font_custom .. "16",
  widget = wibox.widget.textbox
}

local artist_text = wibox.widget {
  text   = "",
  font   = beautiful.font_custom .. "13",
  widget = wibox.widget.textbox
}

local next        = wibox.widget {
  font = beautiful.font_custom .. "25",
  text = ' 󰒭 ',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:next()
    end)
  },
}

local prev        = wibox.widget {
  align = 'center',
  font = beautiful.font_custom .. "25",
  markup = ' 󰒮 ',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}
local play        = wibox.widget {
  align = 'center',
  font = beautiful.font_custom .. "25",
  markup = help.colortext('󰐊', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:play_pause()
    end)
  },
}
playerctl:connect_signal("playback_status", function(_, playing)
  play.markup = playing and help.colortext("󰏤", beautiful.fg) or help.colortext("󰐊", beautiful.fg)
end)

local spotify_widget = wibox.widget {
  {
    cover_art,
    {
      {
        widget = wibox.container.background,
      },
      bg = {
        type = "linear",
        from = { 0, 0 },
        to = { 250, 0 },
        stops = { { 0, beautiful.bg_2 .. "99" }, { 1, beautiful.bg_2 .. '55' } }
      },
      shape = help.rrect(),
      widget = wibox.container.background,
    },
    {
      {
        {
          song_text,
          artist_text,
          layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.margin,
        top = dpi(8),
        left = dpi(8),
      },
      nil,
      {
        {
          {
            prev,
            play,
            next,
            layout = wibox.layout.fixed.horizontal,
          },
          widget = wibox.container.background,
          bg = beautiful.bg_2,
          shape = function(cr)
            return gears.shape.partially_rounded_rect(cr, 120, 50, false, true, true, true)
          end
        },
        widget = wibox.container.margin,
      },
      layout = wibox.layout.align.vertical,
    },
    layout = wibox.layout.stack,
  },
  layout = wibox.layout.align.vertical,
}

playerctl:connect_signal("metadata",
  function(_, title, artist, album_path, album, new, player_name)
    cover_art:set_image(gears.surface.load_uncached(help.cropSurface(2.245,
      gears.surface.load_uncached(album_path and album_path or beautiful.nosongpic))))
    song_text:set_markup_silently(title)
    artist_text:set_markup_silently(artist)
  end)



return spotify_widget
