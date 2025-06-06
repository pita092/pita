local wibox           = require("wibox")
local awful           = require("awful")
local naughty         = require("naughty")
local beautiful       = require("beautiful")
local gears           = require("gears")
local help            = require("core.help")
local dpi             = beautiful.xresources.apply_dpi

local config_dir      = gears.filesystem.get_configuration_dir()
local icon_dir        = config_dir .. 'core/theme/icons/weather/'

local icons           = {
  ["Sunny"]                = "sunny.svg",
  ["Partly cloudy"]        = "partlyCloudy.svg",
  ["Cloudy"]               = "cloudy.svg",
  ["Overcast"]             = "foggy.svg",
  ["Mist"]                 = "foggy.svg",
  ["Patchy rain possible"] = "rain.svg",
  ["Light rain"]           = "rain.svg",
  ["Heavy rain"]           = "rain.svg",
  ["Thunderstorm"]         = "thunderStorm.svg",
  ["Snow"]                 = "snowy.svg",
  ["Fog"]                  = "foggy.svg",
  ["Clear"]                = "cloudy.svg"
}

local default_icon    = "cloudy.svg"

local weather_icon    = wibox.widget {
  widget = wibox.widget.imagebox,
  image  = config_dir .. 'core/theme/icons/apps/firefox.svg',
}

local conditionText   = wibox.widget {
  widget = wibox.widget.textbox,
  text = "Loading...",
  font = beautiful.font_custom .. '15',
  align = "center",
  valign = "center",
}

local temperatureText = wibox.widget {
  widget = wibox.widget.textbox,
  text = "Loading...",
  font = beautiful.icon,
  align = "center",
  valign = "center"
}

local photo           = wibox.widget {
  {
    {
      weather_icon,
      widget = wibox.container.margin,
      margins = {
        top = dpi(25),
        bottom = dpi(-5),
        left = dpi(25),
        right = dpi(25),
      }
    },
    {
      conditionText,
      widget = wibox.container.margin,
      bottom = dpi(10)

    },
    layout = wibox.layout.fixed.vertical,
  },
  widget = wibox.container.background,
  bg = beautiful.bg_1,
  forced_height = 175,
  forced_width = 150,
  shape = help.rrect(),
}

local function display_weather_icon(stdout)
  local condition = stdout:match("^(.-)%s*%|") or ""
  condition = condition:gsub("^%s+", ""):gsub("%s+$", "")

  local temperature = stdout:match("|%s*([^\n]+)") or ""
  temperatureText.text = temperature
  conditionText.markup = help.colortext(condition, beautiful.blue)


  local icon_filename = icons[condition]
  local image = icon_dir .. icon_filename
  weather_icon:set_image(image)
end

local function update_weather_icon()
  awful.spawn.easy_async_with_shell(
    [[curl -s "https://wttr.in/?format=%C%20|%20%t"]],
    function(stdout)
      display_weather_icon(stdout)
    end
  )
end

gears.timer {
  timeout   = 3600,
  call_now  = true,
  autostart = true,
  callback  = function()
    update_weather_icon()
  end
}

local text = wibox.widget {
  {
    {
      {
        {
          {
            widget = wibox.widget.textbox,
            markup = help.colortext("", beautiful.blue) .. " My city",
            font = beautiful.font_custom .. '23',
          },
          widget = wibox.container.place,
          halign = "left"
        },
        temperatureText,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.place,
      halign = "center",
      valign = "center",
    },
    widget = wibox.container.margin,
    margins = dpi(12)
  },
  widget = wibox.container.background,
  bg = beautiful.bg_1,
  forced_height = 175,
  forced_width = 330,
  shape = help.rrect(),
}

return {
  photo = photo,
  text = text
}
