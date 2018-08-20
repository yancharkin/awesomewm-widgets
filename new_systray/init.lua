local wibox = require("wibox")

local ROOT = os.getenv("HOME").."/.config/awesome/new_systray/"
local IMG_MARGIN = 8
local SYSTRAY_MARGIN = 8

local visibility = false

local imagebox_systray = wibox.widget.imagebox()
local container_systray_image = wibox.container.margin(imagebox_systray)
local separator_textbox = wibox.widget.textbox()
container_systray_image.margins = IMG_MARGIN
imagebox_systray:set_image(ROOT.."images/left.svg")

local systray = wibox.widget.systray()
local container_systray = wibox.container.margin(systray)
container_systray.margins = SYSTRAY_MARGIN
container_systray.visible = visibility

local new_systray = wibox.widget {
    container_systray_image,
    container_systray,
    layout = wibox.layout.fixed.horizontal
}

function new_systray.toggle()
    if visibility == true then
        visibility = false
        container_systray.visible = visibility
        imagebox_systray:set_image(ROOT.."images/left.svg")
    else
        visibility = true
        container_systray.visible = visibility
        imagebox_systray:set_image(ROOT.."images/right.svg")
    end
end

imagebox_systray:connect_signal("button::press",
    function()
        new_systray.toggle()
    end
)

return new_systray
