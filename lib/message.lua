-- 消息
local hmessage = {}

-- 在屏幕打印信息给所有玩家
hmessage.echo = function(msg)
    cj.DisplayTextToForce(cj.GetPlayersAll(), msg)
end
-- 在屏幕(x.y)处打印信息给某玩家
hmessage.echoXY = function(whichPlayer, msg, x, y, duration)
    if (duration < 5) then
        cj.DisplayTextToPlayer(whichPlayer, x, y, msg)
    else
        cj.DisplayTimedTextToPlayer(whichPlayer, x, y, duration, msg)
    end
end
-- 在屏幕(0.0)处打印信息给某玩家
hmessage.echoXY0 = function(whichPlayer, msg, duration)
    hmessage.echoXY(whichPlayer, msg, 0, 0, duration)
end

return hmessage
