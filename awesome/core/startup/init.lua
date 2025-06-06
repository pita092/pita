local awful = require("awful")

require("naughty").connect_signal("request::display_error", function(message, startup)
  require("naughty").notification {
    urgency = "critical",
    title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = message
  }
end)



pcall(require, "luarocks.loader")
require("awful.autofocus")

awful.spawn.with_shell("nitrogen --restore")


tag.connect_signal("request::default_layouts", function()
  require("awful").layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.floating,
  })
end)
