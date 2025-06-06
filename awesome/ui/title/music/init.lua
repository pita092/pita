local ruled      = require("ruled")
local beautiful  = require("beautiful")
local awful      = require("awful")
local gears      = require("gears")
local wibox      = require("wibox")
local dpi        = beautiful.xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local help       = require("core.help")
local bling      = require("core.lib.bling")
local playerctl  = bling.signal.playerctl.lib({

  ignore = "firefox",
  player = { "mpd", "%any" }
})




local volumeSlider = wibox.widget {
  bar_shape        = help.rrect(),
  bar_height       = 20,
  handle_width     = 12,
  handle_color     = beautiful.blue,
  bar_color        = beautiful.blue .. '55',
  bar_active_color = beautiful.blue,
  handle_shape     = function(cr)
    return gears.shape.partially_rounded_rect(cr, 12, 20, true, true, true, true, dpi(4))
  end,
  handle_margins   = { top = 4 },
  maximum          = 100,
  value            = 85,
  widget           = wibox.widget.slider,
}

volumeSlider:connect_signal("property::value", function(_, value)
  awful.spawn("pamixer --set-volume " .. math.floor(value), false)
end)

awesome.connect_signal("signal::volume", function(value)
  volumeSlider.value = value
  volumeSlider:emit_signal("property::value", volumeSlider, value)
end)

awful.spawn.easy_async_with_shell(
  "pamixer --get-volume",
  function(out)
    local vol = tonumber(out)
    if vol then
      volumeSlider.value = vol
      volumeSlider:emit_signal("property::value", volumeSlider, vol)
    end
  end
)


local cover_art   = wibox.widget({
  resize = true,
  widget = wibox.widget.imagebox,
  image = gears.surface.load_uncached(config_dir .. "core/theme/icons/colored/nothing.png"),
  clip_shape = help.rrect(),
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

local bar         = wibox.widget {
  bar_shape        = help.rrect(0),
  bar_height       = 12,
  handle_width     = 25,
  handle_color     = beautiful.blue,
  bar_color        = beautiful.blue .. '55',
  bar_active_color = beautiful.blue,
  handle_shape     = function(cr)
    return gears.shape.partially_rounded_rect(cr, 20, 20, true, true, true, true, dpi(4))
  end,
  handle_margins   = { top = 10 },
  forced_height    = 8,
  maximum          = 100,
  widget           = wibox.widget.slider,
}


local shuffleactv = false
local shuffle     = nil
shuffle           = wibox.widget {
  align = 'center',
  font = beautiful.font_custom .. "18",
  markup = help.colortext(' 󰒝 ', beautiful.blue .. '88'),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      shuffleactv = not shuffleactv
      shuffle.markup = shuffleactv and help.colortext(' 󰒝 ', beautiful.blue .. '') or
          help.colortext(' 󰒝 ', beautiful.blue .. '88')
      playerctl:cycle_shuffle()
    end)
  },
}
local loopactv    = false
local loop        = nil
loop              = wibox.widget {
  align = 'center',
  font = beautiful.font_custom .. "18",
  markup = help.colortext('  ', beautiful.blue .. '88'),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      loopactv = not loopactv
      loop.markup = loopactv and help.colortext('  ', beautiful.blue .. '') or
          help.colortext('  ', beautiful.blue .. '88')
      playerctl:cycle_loop_status()
    end)
  },
}




local next = wibox.widget {
  font = beautiful.font_custom .. "25",
  markup = help.colortext(' 󰒭 ', beautiful.fg .. ''),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:next()
    end)
  },
}

local prev = wibox.widget {
  align = 'center',
  font = beautiful.font_custom .. "25",
  markup = help.colortext(' 󰒮 ', beautiful.fg .. ''),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}
local play = wibox.widget {
  align = 'center',
  font = beautiful.font_custom .. "25",
  markup = help.colortext('󰐊', beautiful.fg .. '88'),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:play_pause()
    end)
  },
}


playerctl:connect_signal("playback_status", function(_, playing)
  play.markup = playing and help.colortext("󰏤", beautiful.fg .. '') or help.colortext("󰐊", beautiful.fg .. '88')
end)
local checkthing = false
bar:connect_signal('mouse::enter', function()
  checkthing = true
end)
bar:connect_signal('mouse::leave', function()
  checkthing = false
end)
bar:connect_signal('property::value', function(_, value)
  playerctl:set_position(checkthing and value or nil)
end)

playerctl:connect_signal("position", function(_, interval_sec, length_sec)
  bar.maximum = length_sec or bar.maximum
  bar.value = interval_sec or bar.value
end)

playerctl:connect_signal("metadata",
  function(_, title, artist, album_path, album, new, player_name)
    cover_art:set_image(gears.surface.load_uncached(
      gears.surface.load_uncached(album_path and album_path or beautiful.nosongpic)))
    song_text:set_markup_silently(title)
    artist_text:set_markup_silently(artist)
  end)



local get_titlebar = function(c)
  local container = wibox.widget {
    bg = beautiful.bar,
    shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 0) end,
    widget = wibox.container.background,
  }





  c:connect_signal("focus", function() container.bg_2 = beautiful.bg_2 end)
  c:connect_signal("unfocus", function() container.bg_2 = beautiful.bg_2 end)

  local keyButtons = function(clent, key, icon)
    local widget = wibox.widget({
      align = 'center',
      font = beautiful.font_custom .. "18",
      markup = help.colortext(icon, beautiful.blue .. '9f'),
      widget = wibox.widget.textbox,
      buttons = {
        awful.button({}, 1, function()
          help.keyPress(client, key)
        end)
      },
    })
    return widget
  end

  return wibox.widget {
    {
      bar,
      widget = wibox.container.margin,
      top = -4,
    },
    {
      {
        {
          {
            {
              {
                {
                  song_text,
                  artist_text,
                  layout = wibox.layout.fixed.vertical,
                },
                spacing = dpi(25),
                layout = wibox.layout.fixed.horizontal,
                forced_width = 600,

              },
              align = 'right',
              widget = wibox.container.place
            },
            spacing = 13,
            layout = wibox.layout.fixed.horizontal,
          },

          {
            {
              {
                {
                  prev,
                  {
                    play,
                    margins = 4,
                    widget = wibox.container.margin
                  },
                  next,
                  spacing = 15,
                  layout = wibox.layout.fixed.horizontal,
                  align = "center"
                },
                widget = wibox.container.background,
                bg = beautiful.bg_4 .. '19',
                shape = help.rrect(),
              },
              {
                {
                  shuffle,
                  loop,
                  layout = wibox.layout.fixed.horizontal,
                },
                widget = wibox.container.background,
                bg = beautiful.bg_4 .. "19",
                shape = help.rrect(),
              },
              layout = wibox.layout.fixed.horizontal,
              spacing = dpi(10),

            },
            margins = {
              bottom = 15,
              left = 10,
              right = 10,
            },
            widget = wibox.container.margin,
          },
          {
            {
              {
                keyButtons(c, '8', '   '),
                keyButtons(c, '1', '   '),
                layout = wibox.layout.fixed.horizontal,
              },
              widget = wibox.container.background,
              bg = beautiful.bg_4 .. '19',
              shape = help.rrect(),
            },
            margins = {
              bottom = 15,
              left = 10,
              right = 10,
            },
            widget = wibox.container.margin,
          },
          nil,
          expand = 'none',
          layout = wibox.layout.align.horizontal,
        },
        widget = wibox.container.margin,
        margins = {
          top = 20,
          left = 15
        }
      },
      widget = wibox.container.place,
    },
    layout = wibox.layout.fixed.vertical,
  }
end

local albumarttitle = function(c)
  local container = wibox.widget {
    bg = beautiful.bar,
    shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 0) end,
    widget = wibox.container.background,
  }





  c:connect_signal("focus", function() container.bg_2 = beautiful.bg_2 end)
  c:connect_signal("unfocus", function() container.bg_2 = beautiful.bg_2 end)


  return wibox.widget {
    {
      nil,
      {
        cover_art,
        left = dpi(25),
        right = dpi(25),
        bottom = dpi(10),
        widget = wibox.container.margin,
      },
      {
        {
          {
            markup = help.colortext(' 󰓃 ', beautiful.fg .. ''),
            widget = wibox.widget.textbox,
            font = beautiful.icon,
          },
          volumeSlider,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin,
        margins = {
          left = dpi(12),
          right = dpi(25),
          bottom = dpi(145),
        }
      },
      nil,
      expand = "none",
      layout = wibox.layout.align.vertical,
    },
    bg = beautiful.bg,
    shape = help.rrect(),
    widget = wibox.container.background,
  }
end


local title = function(c)
  awful.titlebar(c, { position = "bottom", size = dpi(115), bg = beautiful.bg_2 }):setup {
    widget = get_titlebar(c)
  }
end
local arttitle = function(c)
  awful.titlebar(c, { position = "left", size = dpi(400), bg = beautiful.bg_2 }):setup {
    widget = albumarttitle(c)
  }
end


gears.timer {
  timeout = 2,
  autostart = true,
  call_now = false,
  callback = function()
    for _, c in ipairs(client.get()) do
      if c.class == "ncmpcppwindow" and c._volume_titlebar then
        c._volume_titlebar:emit_signal("widget::redraw_needed")
        c._volume_titlebar:emit_signal("widget::layout_changed")
      end
    end
  end
}

ruled.client.connect_signal("request::rules", function()
  ruled.client.append_rule {
    id       = "ncmpcppwindow",
    rule     = {
      class = "ncmpcppwindow",
    },
    callback = function(c)
      title(c)
      arttitle(c)
    end
  }
end)
