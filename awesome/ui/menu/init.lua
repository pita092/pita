local wibox      = require("wibox")
local awful      = require("awful")
local help       = require("core.help")
local beautiful  = require("beautiful")
local dpi        = beautiful.xresources.apply_dpi
local gears      = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
local terminal   = "st"
local editor     = "nvim"
local editor_cmd = terminal .. 'e' .. editor


beautiful.menu_height    = dpi(30)
beautiful.menu_width     = dpi(200)
beautiful.menu_bg_focus  = beautiful.bg_2
beautiful.menu_fg_focus  = beautiful.blue
beautiful.menu_bg_normal = beautiful.bg_2
beautiful.submenu        = ""
myawesomemenu            = {
  { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual",      terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  { "restart",     awesome.restart },
}

mymainmenu               = awful.menu({
  items = {
    { "     󰍜", myawesomemenu },
  },
})
mymainmenu.wibox.shape   = help.rrect(dpi(4))
