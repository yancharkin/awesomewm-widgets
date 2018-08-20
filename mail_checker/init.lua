local os = os
local io = io

local wibox = require("wibox")
local awful = require("awful")

local ROOT = os.getenv("HOME").."/.config/awesome/mail_checker/"
local FONT = "Source\ Code\ Pro Regular 16"
local IMG_NONEW = ROOT.."images/nonew.svg"
local IMG_NEW = ROOT.."images/new.svg"
local IMG_MARGIN = 9
local CHECK_INTERVAL = 300
local MAIL_CLIENT = "sakura --execute mutt"
local SHOW_EMPTY = false

local launcher_mail = awful.widget.launcher({image = IMG_NONEW, command = MAIL_CLIENT})
local container_mail = wibox.container.margin(launcher_mail)
local textbox_mail = wibox.widget.textbox()
container_mail.margins = IMG_MARGIN
textbox_mail:set_font(FONT)
local mail_checker = wibox.widget {
    container_mail,
    textbox_mail,
    layout = wibox.layout.fixed.horizontal
}

local function update_mail_indicator(unread)
    unread = tonumber(unread)
    if unread then
        if tonumber(unread) > 0 then
            launcher_mail:set_image(IMG_NEW)
            textbox_mail:set_markup('<span foreground="#99e550">'..unread..'</span>')
        else
            launcher_mail:set_image(IMG_NONEW)
            textbox_mail:set_text("")
        end
    end
end

function check_mail()
    mail_checker = io.popen("python "..ROOT.."mail_checker.py", "r")
    unread = mail_checker:read()
    mail_checker:close()
    update_mail_indicator(unread)
end

awful.widget.watch(
    "python "..ROOT.."mail_checker.py", CHECK_INTERVAL,
    function(widget, stdout)
        update_mail_indicator(stdout)
    end
)

return mail_checker
