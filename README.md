# awesomewm-widgets
Simple widgets for Awesome WM

**new_systray** - toggle systray visibility
**mail_checker** - checks periodically for new emails
**weather_checker** - get current weather from darksky.net

![screenshot](screenshot.png  "Screenshot")

## Installation
Clone/extract to **$HOME/.config/awesome/**

Add at the beginning of the **$HOME/.config/awesome/rc.lua**:

    local new_systray = require("new_systray")
    local mail_checker = require("mail_checker")
    local weather_checker = require("weather_checker")


Add widget to wibox:

    s.mytasklist,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            new_systray,
            mail_checker,
            weather_checker,
            mytextclock,
            mykeyboardlayout,
            s.mylayoutbox,
        },
