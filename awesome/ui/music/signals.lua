local animation = require("core.animation")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local M = require("ui.music")

awesome.connect_signal("quit::music", function()
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

awesome.connect_signal("toggle::music", function()
  local is_visible = M.control_c.visible and M.control_c.y > -M.control_c.height

  if is_visible then
    awesome.emit_signal("quit::music")
  else
    M.control_c.visible = true
    awful.placement.top_right(
      M.control_c,
      { honor_workarea = true, margins = { right = 1910 - M.control_c.width } }
    )
    if M.control_c.animation then
      M.control_c.animation:stop()
    end

    local calendar_visible = require("ui.calendar").control_c.visible
    local lock_visible = require("ui.lock").wibox.visible

    local target
    if lock_visible then
      target = dpi(890)
    elseif calendar_visible then
      target = dpi(875)
    else
      target = dpi(83)
    end
    M.control_c.animation = animation.slide_y(M.control_c, {
      start = -M.control_c.height,
      target = target,
      duration = 0.55,
      easing = animation.easing.cubic,
      complete = function()
        M.control_c.animation = nil
      end
    })
  end
end)
