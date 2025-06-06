local wibox      = require("wibox")
local naughty    = require("naughty")
local awful      = require("awful")
local gears      = require("gears")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local help       = require("core.help")
local config_dir = gears.filesystem.get_configuration_dir()



local function button(image, color, action)
  local icon = wibox.widget {
    widget = wibox.widget.imagebox,
    image = gears.color.recolor_image(config_dir .. image, color),
    clip_shape = help.rrect(),
    resize = true,
  }

  local container = wibox.widget {
    icon,
    widget = wibox.container.margin,
    margins = dpi(0),
  }

  container:buttons(gears.table.join(
    awful.button({}, 1, nil, action)
  ))

  return container
end

local minimize = function()
  if client.focus then
    client.focus.minimized = true
  end
end

local close = function()
  if client.focus then
    client.focus:kill()
  end
end

local maximize = function()
  if client.focus then
    client.focus.maximized = not client.focus.maximized
    client.focus:raise()
  end
end



local get_titlebar = function(c)
  local container = wibox.widget {
    bg = beautiful.bar,
    shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 0) end,
    widget = wibox.container.background,
  }

  local buttons = gears.table.join({
    awful.button({}, 1, function()
      c:activate { context = "titlebar", action = "mouse_move" }
    end),
    awful.button({}, 3, function()
      c:activate { context = "titlebar", action = "mouse_resize" }
    end)
  })

  local middle = wibox.widget {
    buttons = buttons,
    layout = wibox.layout.fixed.horizontal,
  }



  local right = wibox.widget {
    {
      {
        widget = wibox.widget.imagebox,
        image = (function()
          local icons = {
            ["firefox"] = config_dir .. "/core/theme/icons/apps/firefox.svg",
            ["^st"] = config_dir .. "/core/theme/icons/apps/terminal.svg",
            ["^chrome"] = config_dir .. "/core/theme/icons/apps/chrome.svg",
            ["ncmpcppwindow"] = config_dir .. "/core/theme/icons/apps/music.svg",
            ["vesktop"] = config_dir .. "/core/theme/icons/apps/discord.svg",
            ["^weather"] = config_dir .. "/core/theme/icons/apps/weather.svg",
          }
          local default_icon = config_dir .. "/core/theme/icons/apps/default.svg"
          local class = c.class and c.class:lower() or ""
          for pattern, path in pairs(icons) do
            if class:match(pattern) then
              return path
            end
          end
          return default_icon
        end)(),
        clip_shape = help.rrect(),
        resize = true,
      },
      widget = wibox.container.margin,
      margins = 2,
    },
    widget = wibox.container.background,
    bg = beautiful.bg_2,
  }

  local left = wibox.widget {
    {
      {
        {

          button("core/theme/icons/google/minus.svg", beautiful.blue, minimize),
          button("core/theme/icons/google/x.svg", beautiful.red, close),
          button("core/theme/icons/google/plus.svg", beautiful.green, maximize),
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(7),
        },
        widget = wibox.container.margin,
        margins = 5,
      },
      layout = wibox.layout.align.horizontal,
    },
    shape = help.rrect(),
    widget = wibox.container.background,
    bg = beautiful.bg_2,
  }


  c:connect_signal("focus", function() container.bg_2 = beautiful.bg_2 end)
  c:connect_signal("unfocus", function() container.bg_2 = beautiful.bg_2 end)

  return wibox.widget {
    {
      {
        left,
        middle,
        right,
        layout = wibox.layout.align.horizontal,
      },
      shape = help.rrect(),
      widget = wibox.container.background,
      bg = beautiful.bg_2,
    },
    margins = { top = dpi(5), bottom = dpi(5), left = dpi(5), right = dpi(5) },
    widget = wibox.container.margin,
  }
end

local title = function(c)
  local top_titlebar = awful.titlebar(c, {
    position = "top",
    size     = 40,
  })
  top_titlebar:setup {
    widget = get_titlebar(c)
  }
end
client.connect_signal("request::titlebars", function(c)
  title(c)
  -- naughty.notify({
  --   title = "Class Debug",
  --   text = tostring(beautiful.nosongpic)
  -- })
end)

require("ui.title.music")
