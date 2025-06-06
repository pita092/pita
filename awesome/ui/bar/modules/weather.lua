local wibox         = require("wibox")
local awful         = require("awful")
local help          = require("core.help")
local beautiful     = require("beautiful")
local gears         = require("gears")
local naughty       = require("naughty")

local icons         = {
  ["Sunny"] = " ",
  ["Partly cloudy"] = " ",
  ["Cloudy"] = " ",
  ["Overcast"] = " ",
  ["Mist"] = " ",
  ["Patchy rain possible"] = " ",
  ["Light rain"] = " ",
  ["Heavy rain"] = " ",
  ["Thunderstorm"] = " ",
  ["Snow"] = " ",
  ["Fog"] = " ",
  ["Clear"] = " "
}

local default_icon  = " "

local weather       = wibox.widget({
  widget = wibox.widget.textbox,
  markup = "wait",
  font   = beautiful.font,
})

-- Cache
local cache_file    = "/tmp/awesome_weather_cache"
local cache_timeout = 3600 -- seconds

local function read_cache()
  local f = io.open(cache_file, "r")
  if not f then return nil end
  local timestamp = tonumber(f:read("*l"))
  local content = f:read("*a")
  f:close()
  if not timestamp or os.time() - timestamp > cache_timeout then
    return nil
  end
  return content
end

local function write_cache(data)
  local f = io.open(cache_file, "w")
  if not f then return end
  f:write(os.time() .. "\n" .. data)
  f:close()
end

local function display_weather(stdout)
  local condition = stdout:match("^(.-)%s*%|") or ""
  condition = condition:gsub("^%s+", ""):gsub("%s+$", "")

  local temperature = stdout:match("|%s*([^\n]+)") or ""
  local icon = icons[condition] or default_icon

  local icon_markup = '<span size="17000">' .. icon .. ' </span>'

  weather.markup = help.colortext(' ' .. icon_markup .. '<span size = "17000">' .. temperature .. '</span>' .. ' ', beautiful.fg .. '98')
end

local function getWeather()
  local cached = read_cache()
  if cached then
    display_weather(cached)
  else
    awful.spawn.easy_async_with_shell(
      [[curl -s "https://wttr.in/?format=%C%20|%20%t"]],
      function(stdout)
        write_cache(stdout)
        display_weather(stdout)
      end
    )
  end
end

gears.timer {
  timeout   = cache_timeout,
  call_now  = true,
  autostart = true,
  callback  = getWeather
}

return {
  getWeather = getWeather,
  widget = weather
}
