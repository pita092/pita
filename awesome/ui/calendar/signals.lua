local animation = require("core.animation")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi


local M         = require("ui.calendar")

awesome.connect_signal("quit::calendar", function()
  if M.control_c.visible then
    if M.control_c.animation then
      M.control_c.animation:stop()
    end

    M.control_c.animation = animation.slide_y(M.control_c, {
      start = 22,
      target = -M.control_c.height,
      duration = 0.2,
      easing = animation.easing.cubic,
      complete = function()
        M.control_c.visible = false
        M.control_c_grabber:stop()
        M.control_c.animation = nil
      end
    })
  end
end)

awesome.connect_signal("toggle::calendar", function()
  local is_visible = M.control_c.visible and M.control_c.y > -M.control_c.height

  if is_visible then
    awesome.emit_signal("quit::calendar")
  else
    -- if require("ui.music").control_c.visible then
    --   awesome.emit_signal("toggle::music")
    -- end
    -- if require("ui.lock").wibox.visible then
    --   awesome.emit_signal("toggle::lock")
    -- end
    M.control_c.visible = true
    if M.control_c.animation then
      M.control_c.animation:stop()
    end
    if (require("ui.lock").wibox.visible or require("ui.music").control_c.visible) then
      awful.placement.top_right(
        M.control_c,
        { honor_workarea = true, margins = { top = dpi(12), right = 1910 - M.control_c.width } }
      )
      M.control_c.animation = animation.slide(M.control_c, {
        start = dpi(12),
        target = dpi(625),
        duration = 0.4,
        easing = animation.easing.cubic,
        complete = function()
          M.control_c.animation = nil
        end
      })
    else
      awful.placement.top_right(
        M.control_c,
        { honor_workarea = true, margins = { top = dpi(-M.control_c.height + -200), right = 1910 - M.control_c.width } }
      )
      M.control_c.animation = animation.slide_y(M.control_c, {
        start = -M.control_c.height,
        target = dpi(83),
        duration = 0.4,
        easing = animation.easing.cubic,
        complete = function()
          M.control_c.animation = nil
        end
      })
    end
  end
end)
