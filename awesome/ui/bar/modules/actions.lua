local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local help      = require("core.help")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local animation = require("core.animation")


local is_expanded = false

local controller_icon = wibox.widget({
  widget = wibox.widget.textbox,
  markup = help.colortext(" ", beautiful.fg .. '88'),
  font = beautiful.icon,
})

local function make_icon_with_bg(icon_markup, on_click)
  local icon_widget = wibox.widget({
    {
      widget = wibox.widget.textbox,
      markup = icon_markup,
      font = beautiful.font_custom .. '20',
    },
    widget = wibox.container.margin,
    margins = dpi(8)
  })

  if on_click then
    icon_widget:buttons(gears.table.join(
      awful.button({}, 1, nil, on_click)
    ))
  end

  local bg_container = wibox.container.background()
  bg_container.bg = beautiful.bg_1
  bg_container.shape = help.rrect()
  bg_container.widget = icon_widget
  return bg_container
end

local actions = {
  make_icon_with_bg(help.colortext("󰌧 ", beautiful.fg .. "aa"), function()
    awful.spawn.with_shell("dmenu_run")
  end),
  make_icon_with_bg(help.colortext(" ", beautiful.fg .. "aa"), function()
    gears.timer({
      timeout = 0.5,
      autostart = true,
      single_shot = true,
      callback = function()
        awful.spawn.with_shell("xcol")
      end,
    })
  end),
  make_icon_with_bg(help.colortext(" ", beautiful.fg .. "aa"), function()
    gears.timer({
      timeout = 0.5,
      autostart = true,
      single_shot = true,
      callback = function()
        awful.spawn.with_shell("xkill")
      end,
    })
  end),
}

local icon_layout = wibox.layout.fixed.horizontal()

icon_layout:add(controller_icon)

local function create_first_spacer()
  return wibox.widget {
    forced_width = 22,
    layout = wibox.layout.fixed.horizontal,
  }
end

local function create_spacer()
  return wibox.widget {
    forced_width = 4,
    layout = wibox.layout.fixed.horizontal,
  }
end

icon_layout:add(create_first_spacer())

for i, icon in ipairs(actions) do
  icon.visible = false
  icon_layout:add(icon)
  if i < #actions then
    icon_layout:add(create_spacer())
  end
end

local widget = wibox.widget({
  {
    icon_layout,
    widget = wibox.container.margin,
    left = 11,
  },
  widget = wibox.container.background,
  bg = beautiful.bg_1,
  shape = help.rrect(),
  forced_width = 40,
})

controller_icon:buttons(gears.table.join(awful.button({}, 1, function()
  is_expanded = not is_expanded

  for _, icon in ipairs(actions) do
    icon.visible = is_expanded
  end

  local target_width = is_expanded and 200 or 40
  animation.resize(widget, {
    start_width = widget.width or widget.forced_width,
    start_height = widget.height or 100,
    target_width = target_width,
    target_height = widget.height or 100,
    duration = 0.3,
    easing = animation.easing.cubic,
    on_resize = function(w)
      widget.forced_width = w
    end,
  })
end)))

return widget
