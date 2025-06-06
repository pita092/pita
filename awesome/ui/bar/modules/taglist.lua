local wibox     = require("wibox")
local awful     = require("awful")
local help      = require("core.help")
local beautiful = require("beautiful")


local M = {}
function M.create_taglist(s)
  local taglist = awful.widget.taglist {
    screen          = s,
    filter          = awful.widget.taglist.filter.all,
    style           = {
      shape = help.rrect()
    },
    buttons         = {
      awful.button({}, 1, function(t)
        t:view_only()
      end),
      awful.button({}, 4, function(t)
        awful.tag.viewprev(t.screen)
      end),
      awful.button({}, 5, function(t)
        awful.tag.viewnext(t.screen)
      end)
    },
    layout          = {
      spacing = 4,
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      {
        {
          markup = '',
          shape  = help.rrect(),
          widget = wibox.widget.textbox,
        },
        valign        = 'center',
        id            = 'background_role',
        shape         = help.rrect(),
        widget        = wibox.container.background,
        forced_width  = 45,
        forced_height = 18,
      },
      widget = wibox.container.place,
      update_callback = function(self, tag, index, objects)
        if awful.screen.focused().selected_tag and awful.screen.focused().selected_tag.index == index then
          self:get_children_by_id('background_role')[1].color = beautiful.blue
        end
      end

    },
  }

  return taglist
end

return M
