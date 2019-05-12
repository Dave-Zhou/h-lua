local htime = {
    -- 累计秒
    count = 0,
    -- 时
    hour = 0,
    -- 分
    min = 0,
    -- 秒
    sec = 0
}
-- 时钟
htime.clock = function()
    htime.count = htime.count + 1
    htime.sec = htime.sec + 1
    if (htime.sec >= 60) then
        htime.sec = 0
        htime.min = htime.min + 1
        if (htime.min >= 60) then
            htime.hour = htime.hour + 1
            htime.min = 0
        end
    end
    if (console.enable ~= true) then
        cj.FogEnable(true)
        cj.FogMaskEnable(true)
    end
end
-- 获取时分秒
htime.his = function()
    local str = ""
    if (htime.hour < 10) then
        str = str .. "0" .. htime.hour
    else
        str = str .. htime.hour
    end
    str = str .. ":"
    if (htime.min < 10) then
        str = str .. "0" .. htime.min
    else
        str = str .. htime.min
    end
    str = str .. ":"
    if (htime.sec < 10) then
        str = str .. "0" .. htime.sec
    else
        str = str .. htime.sec
    end
    return str
end
-- 获取计时器设置时间
htime.getSetTime = function(t)
    if (t == nil) then
        return 0
    else
        return cj.TimerGetTimeout(t)
    end
end
-- 获取计时器剩余时间
htime.getRemainTime = function(t)
    if (t == nil) then
        return 0
    else
        return cj.TimerGetRemaining(t)
    end
end

-- 获取计时器已过去时间
htime.getElapsedTime = function(t)
    if (t == nil) then
        return 0
    else
        return cj.TimerGetElapsed(t)
    end
end
-- 设置一次性计时器
htime.setTimeout = function(time, title, myfunc)
    local t = cj.CreateTimer()
    local td
    if (title ~= nil) then
        td = cj.CreateTimerDialog(t)
        cj.TimerDialogSetTitle(td, title)
        cj.TimerDialogDisplay(td, false)
    end
    cj.TimerStart(t, time, false, function()
        myfunc(t, td)
    end)
    return t
end
-- 设置周期性计时器
htime.setInterval = function(time, title, myfunc)
    local t = cj.CreateTimer()
    local td
    if (title ~= nil) then
        td = cj.CreateTimerDialog(t)
        cj.TimerDialogSetTitle(td, title)
        cj.TimerDialogDisplay(td, true)
    end
    cj.TimerStart(t, time, true, function()
        myfunc(t, td)
    end)
    return t
end
-- 删除计时器Q
htime.delTimer = function(t)
    if (t == nil) then
        return
    end
    cj.PauseTimer(t)
    cj.DestroyTimer(t)
end
-- 删除计时器窗口
htime.delDialog = function(td)
    if (td == nil) then
        return
    end
    cj.DestroyTimerDialog(td)
end

return htime
