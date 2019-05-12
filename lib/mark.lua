---遮罩
local hmark = {}
--- 显示
hmark.show = function(whichPlayer)
    if (whichPlayer == nil) then
        cj.DisplayCineFilter(true)
    elseif (whichPlayer == cj.GetLocalPlayer()) then
        cj.DisplayCineFilter(true)
    end
end
--- 隐藏
hmark.hide = function(whichPlayer)
    if (whichPlayer == nil) then
        cj.DisplayCineFilter(false)
    elseif (whichPlayer == cj.GetLocalPlayer()) then
        cj.DisplayCineFilter(false)
    end
end
--- 展示
hmark.display = function(whichPlayer, path, through, startPercent, endPercent, during)
    if (whichPlayer == nil) then
        bj.CinematicFilterGenericBJ(through, BLEND_MODE_ADDITIVE, path, startPercent, startPercent, startPercent, 90.00, endPercent, endPercent, endPercent, 0.00)
    elseif (whichPlayer == cj.GetLocalPlayer()) then
        bj.CinematicFilterGenericBJ(through, BLEND_MODE_ADDITIVE, path, startPercent, startPercent, startPercent, 90.00, endPercent, endPercent, endPercent, 0.00)
    end
    if (during < through + 1) then
        during = through + 1
    end
    htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        hmark.hide(whichPlayer)
    end)
end

return hmark
