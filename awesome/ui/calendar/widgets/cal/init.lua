--i stright up stole this from namish (please dont sue me) https://github.com/namishh/crystal/blob/aura
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local gears     = require("gears")
local help      = require("core.help")

local function make_widget(text, is_current, padding_type)
  local fg_color
  if is_current then
    fg_color = beautiful.blue
  elseif padding_type == "prev" then
    fg_color = beautiful.fg .. '88'
  elseif padding_type == "next" then
    fg_color = beautiful.fg .. '88'
  else
    fg_color = nil
  end

  return wibox.widget {
    markup = fg_color and help.colortext(tostring(text), fg_color) or tostring(text),
    halign = "center",
    font   = beautiful.icon,
    widget = wibox.widget.textbox,
  }
end

local title = wibox.widget {
  font = beautiful.icon,
  widget = wibox.widget.textbox,
  halign = "center"
}

local theGrid = wibox.widget {
  forced_num_rows = 7,
  forced_num_cols = 7,
  vertical_spacing = dpi(10),
  horizontal_spacing = dpi(10),
  min_cols_size = dpi(30),
  min_rows_size = dpi(30),
  homogenous = true,
  layout = wibox.layout.grid,
}

local updateCalendar = function(date)
  title.markup = os.date("%B " .. help.colortext("%Y", beautiful.blue), os.time(date))
  theGrid:reset()

  -- Add weekdays headers
  for _, day in ipairs { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" } do
    theGrid:add(make_widget(day))
  end

  local firstDate = os.date("*t", os.time { year = date.year, month = date.month, day = 1 })
  local lastDate = os.date("*t", os.time { year = date.year, month = date.month + 1, day = 0 })

  local padding_start = firstDate.wday - 1
  local padding_end = 42 - lastDate.day - padding_start
  local prevMonthLastDay = os.date("*t", os.time { year = date.year, month = date.month, day = 0 }).day

  local row, col = 2, firstDate.wday

  -- Previous month padding days (dark gray)
  for day = prevMonthLastDay - padding_start + 1, prevMonthLastDay do
    theGrid:add(make_widget(day, false, "prev"))
  end

  -- Current month days
  for day = 1, lastDate.day do
    local is_current = (day == date.day)
    theGrid:add_widget_at(make_widget(day, is_current, nil), row, col)

    col = col % 7 + 1
    if col == 1 then
      row = row + 1
    end
  end

  -- Next month padding days (lighter gray)
  for day = 1, padding_end do
    theGrid:add(make_widget(day, false, "next"))
  end
end

return function()
  local curr = os.date("*t")
  updateCalendar(curr)

  gears.timer {
    timeout   = 60,
    call_now  = true,
    autostart = true,
    callback  = function()
      curr = os.date("*t")
      updateCalendar(curr)
    end
  }

  return wibox.widget {
    {
      {
        {
          nil,
          title,
          nil,
          layout = wibox.layout.align.horizontal,
        },
        {
          theGrid,
          widget = wibox.container.place,
          halign = "center",
        },
        spacing = 17,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.margin,
      margins = 12,
    },
    shape = help.rrect(),
    widget = wibox.container.background,
    bg = beautiful.bg_1,
  }
end
