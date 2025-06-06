require("core.startup")

local req = {
  "core.rules",
  "core.keys",
  "core.theme",
  "ui",
}
local gears = require("gears")
local help = require("core.help")
local ruled = require("ruled")

for _, i in ipairs(req) do
  require(i)
end
client.connect_signal("mouse::enter", function(c)
  c:activate { context = "mouse_enter", raise = false }
end)

client.connect_signal("manage", function(c)
  c.shape = help.rrect()
end)

gears.timer {
  timeout = 7,
  autostart = true,
  call_now = true,
  callback = function()
    collectgarbage("collect")
  end,
}



--experimets

ruled.client.connect_signal("request::rules", function()
  ruled.client.append_rule {
    id = "ncmpcppwindow",
    rule = { class = "ncmpcppwindow" },
    properties = {
      floating = true,
      width = 500,
      height = 500,
    },
    callback = function(c)
      c:geometry({
        x = (1920 - 800) / 2,
        y = (1080 - 500) / 2,
        width = 1000,
        height = 735,
      })
      c:raise()
      client.focus = c
    end
  }
end)




-- ruled.client.connect_signal("request::rules", function()
--   ruled.client.append_rule {
--     id       = "ncmpcppwindow",
--     rule     = {
--       class = "ncmpcppwindow",
--     },
--     callback = function(c)
--     end
--   }
-- end)
