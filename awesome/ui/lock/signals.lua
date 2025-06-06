local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local animation = require("core.animation")



local calInc = false
local musicInc = false

local M = require("ui.lock")
awesome.connect_signal("toggle::lock", function()
  local is_visible = M.wibox.visible and M.wibox.y > -M.wibox.height

  calInc = require("ui.calendar").control_c.visible
  musicInc = require("ui.music").control_c.visible

  if musicInc then
    awesome.emit_signal("toggle::music")
  end
  if calInc then
    awesome.emit_signal("toggle::calendar")
  end

  if not is_visible then
    M.wibox.visible = true
    awful.placement.top(
      M.wibox,
      { honor_workarea = true, margins = { top = -M.wibox.height, right = 1900 - M.wibox.width } }
    )

    if M.wibox.animation then
      M.wibox.animation:stop()
    end
    M.wibox.animation = animation.slide_y(M.wibox, {
      start = -M.wibox.height,
      target = dpi(83),
      duration = 0.3,
      easing = animation.easing.cubic,
      complete = function()
        M.wibox.animation = nil
        if calInc and not require("ui.calendar").control_c.visible then
          awesome.emit_signal("toggle::calendar")
        end
        if musicInc and not require("ui.music").control_c.visible then
          awesome.emit_signal("toggle::music")
        end
      end
    })
  else
    awesome.emit_signal("unlock::lock")
  end
end)


awesome.connect_signal("unlock::lock", function()
  if M.wibox.animation then
    M.wibox.animation:stop()
  end

  M.wibox.animation = animation.slide_y(M.wibox, {
    start = dpi(83),
    target = -M.wibox.height,
    duration = 0.3,
    easing = animation.easing.cubic,
    complete = function()
      M.wibox.visible = false
      M.wibox.animation = nil
    end
  })
end)
