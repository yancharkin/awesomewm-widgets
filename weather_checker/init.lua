local os = os
local io = io
local wibox = require("wibox")
local awful = require("awful")

local ROOT = os.getenv("HOME").."/.config/awesome/weather_checker/"
local CHECK_INTERVAL = 900
local IMG_MARGIN = 6
local FONT = "Source\ Code\ Pro Regular 16"
local W_HOT = 29
local W_COLD = -5
local COLOR_HOT = "'#ffa560'"
local COLOR_NORMAL = "'#cdf3cd'"
local COLOR_COLD = "'#65c4ff'"

local icons_list = {
        "clear-day.svg", "clear-night.svg", "cloudy.svg", "foggy.svg",
        "partly-cloudy-day.svg", "partly-cloudy-night.svg", "rain.svg",
        "sleet.svg", "snow.svg", "wind.svg"
}

local imagebox_weather = wibox.widget.imagebox()
local container_weather = wibox.container.margin(imagebox_weather)
local textbox_weather = wibox.widget.textbox()
container_weather.margins = IMG_MARGIN
textbox_weather:set_font(FONT)
local weather_checker = wibox.widget {
    container_weather,
    textbox_weather,
    layout = wibox.layout.fixed.horizontal
}

function recolor_icons(color, dir)
    for i, filename in ipairs(icons_list) do
        filepath = ROOT.."/images/"..dir.."/"..filename
        new_content = {}
        f = io.open(filepath, "r")
        for line in io.lines(filepath) do
            if string.find(line, "style=") ~= nil then
                new_line = '     style="clip-rule:evenodd;fill-rule:evenodd;fill:'
                        ..color..';fill-opacity:1" /></svg>'
                table.insert(new_content, new_line)
            else
                table.insert(new_content, line)
            end
        end
        f:close()
        f = io.open(filepath, "w")
        for i, v in ipairs(new_content) do
            f:write(v.."\n")
        end
        f:close()
    end
end

recolor_icons(COLOR_HOT, "hot")
recolor_icons(COLOR_NORMAL, "normal")
recolor_icons(COLOR_COLD, "cold")

function update_weather_indicator(data)
    temperature, icon_name = data:match("([^,]+),([^,]+)")
    if temperature ~= nil then
        temperature_striped = temperature:gsub("˚", "")
        temperature_number = tonumber(temperature_striped)
        icon_name = icon_name:gsub("\n", "")
        if temperature_number >= W_HOT then
            COLOR = COLOR_HOT
            imagebox_weather:set_image(ROOT.."images/hot/"..icon_name)
        elseif temperature_number <= W_COLD then
            COLOR = COLOR_COLD
            imagebox_weather:set_image(ROOT.."images/cold/"..icon_name)
        else
            COLOR = COLOR_NORMAL
            imagebox_weather:set_image(ROOT.."images/normal/"..icon_name)
        end
        textbox_weather:set_markup("<span foreground="..COLOR..">"..temperature..'</span>')
    end
end

function check_weather()
    textbox_weather:set_text("?")
    weather_checker = io.popen("python "..ROOT.."weather_checker.py", "r")
    data = weather_checker:read()
    weather_checker:close()
    if data ~= "Error" then
        update_weather_indicator(data)
    end
end

awful.widget.watch(
    "python "..ROOT.."weather_checker.py", CHECK_INTERVAL,
    function(widget, stdout)
        if stdout ~= "Error" then
            update_weather_indicator(stdout)
        end
    end
)

weather_checker:connect_signal("button::press",
    function()
        check_weather()
    end
)

return weather_checker
