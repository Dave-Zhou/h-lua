-- 特效
local heffect = {}

--删除特效
heffect.del = function(e)
    if (e ~= null) then
        cj.DestroyEffect(e)
    end
end
-- 特效 XY坐标
-- during -1为固定存在（需要手动删除）0为删除型创建（但是有的模型用此方法不会播放，此时需要during>0）
heffect.toXY = function(effectModel, x, y, during)
    if (effectModel == nil) then
        return
    end
    local eff
    if (during > 0) then
        eff = cj.AddSpecialEffect(effectModel, x, y)
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    elseif (during < 0) then
        eff = cj.AddSpecialEffect(effectModel, x, y)
        htime.setTimeout(90, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    else
        eff = cj.AddSpecialEffect(effectModel, x, y)
        cj.DestroyEffect(eff)
    end
    return eff
end
-- 特效 点
-- during -1为固定存在（需要手动删除）0为删除型创建（但是有的模型用此方法不会播放，此时需要during>0）
heffect.toLoc = function(effectModel, loc, during)
    if (effectModel == nil or loc == nil) then
        return
    end
    local eff
    if (during > 0) then
        eff = cj.AddSpecialEffectLoc(effectModel, loc)
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    elseif (during < 0) then
        eff = cj.AddSpecialEffectLoc(effectModel, loc)
        htime.setTimeout(90, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    else
        eff = cj.AddSpecialEffectLoc(effectModel, x, y)
        cj.DestroyEffect(eff)
    end
    return eff
end
-- 特效 单位所处位置
-- during -1为固定存在（需要手动删除）0为删除型创建（但是有的模型用此方法不会播放，此时需要during>0）
heffect.toUnit = function(effectModel, targetUnit, during)
    if (effectModel == nil or targetUnit == nil) then
        return
    end
    local eff
    local x = cj.GetUnitX(targetUnit)
    local y = cj.GetUnitY(targetUnit)
    if (during > 0) then
        eff = cj.AddSpecialEffect(effectModel, x, y)
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    elseif (during < 0) then
        eff = cj.AddSpecialEffect(effectModel, x, y)
        htime.setTimeout(90, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    else
        eff = cj.AddSpecialEffect(effectModel, x, y)
        cj.DestroyEffect(eff)
    end
    return eff
end
-- 特效 绑定单位
-- during -1为固定存在（需要手动删除）0为删除型创建（但是有的模型用此方法不会播放，此时需要during>0）
heffect.bindUnit = function(effectModel, targetUnit, attach, during)
    if (effectModel == nil or targetUnit == nil or attach == nil) then
        return
    end
    local eff
    if (during > 0) then
        eff = cj.AddSpecialEffectTarget(effectModel, targetUnit, attach)
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    elseif (during < 0) then
        eff = cj.AddSpecialEffectTarget(effectModel, targetUnit, attach)
        htime.setTimeout(90, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.DestroyEffect(eff)
        end)
    else
        eff = cj.AddSpecialEffectTarget(effectModel, targetUnit, attach)
        cj.DestroyEffect(eff)
    end
    return eff
end

return heffect
