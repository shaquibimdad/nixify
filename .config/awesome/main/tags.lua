local awful = require("awful")

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
   -- set_wallpaper(s)
-- Each screen has its own tag table.
awful.tag({ "1", "2", "3", "4", "5", "6"}, s, awful.layout.layouts[1])

end)