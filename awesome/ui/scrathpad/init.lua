local term_scratch = bling.module.scratchpad {
  command                 = "exec ~/.local/bin/music",
  rule                    = { instance = "ncmpcppwindow" },
  sticky                  = true,
  autoclose               = true,
  floating                = true,
  geometry                = { x = 360, y = 90, height = 900, width = 1200 },
  reapply                 = true,
  dont_focus_before_close = false,
}

return term_scratch
