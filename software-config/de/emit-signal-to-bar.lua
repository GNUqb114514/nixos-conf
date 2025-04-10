local fcitx = require("fcitx")

-- 定义输入法切换事件处理函数
function handle_im_event(_)
    os.execute('pkill -SIGRTMIN+4 i3status-rs')
end

-- 注册事件监听
fcitx.watchEvent(fcitx.EventType.InputMethodActivated, "handle_im_event")
fcitx.watchEvent(fcitx.EventType.InputMethodDeactivated, "handle_im_event")
fcitx.watchEvent(fcitx.EventType.SwitchInputMethod, "handle_im_event")
