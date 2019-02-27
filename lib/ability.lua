habilityCache = {}
hability = {
    ABILITY_TOKEN = hslk_global.unit_token,
    ABILITY_BREAK = hslk_global.ability_break,
    ABILITY_SWIM = hslk_global.ability_swim_unlimit,
    ABILITY_AVOID_PLUS = hslk_global.attr.avoid.add,
    ABILITY_AVOID_MIUNS = hslk_global.attr.avoid.sub,
    BUFF_SWIM = hsystem.getObjId('BPSE'),
}

---打断
-- ! 注意这个方法对中立被动无效
hability.broken = function(u)
    local cu = hunit.create({
        id = hability.ABILITY_TOKEN,
        whichPlayer = hplayer.player_passive,
        x = cj.GetUnitX(u),
        y = cj.GetUnitY(u),
    })
    cj.UnitAddAbility(cu, hability.ABILITY_BREAK)
    cj.SetUnitAbilityLevel(cu, hability.ABILITY_BREAK, 1)
    cj.IssueTargetOrder(cu, "thunderbolt", u)
    hunit.del(cu, 0.3)
end

---眩晕
-- ! 注意这个方法对中立被动无效
hability.swim = function(u, during)
    if (habilityCache[u] == nil) then
        habilityCache[u] = {}
    end
    local t = habilityCache[u].swimTimer
    if (t ~= nil and cj.TimerGetRemaining(t) > 0) then
        if (during <= cj.TimerGetRemaining(t)) then
            return
        else
            htime.delTimer(t)
            habilityCache[u].swimTimer = nil
            cj.UnitRemoveAbility(u, hability.BUFF_SWIM)
            httg.style(httg.create2Unit(u, "劲眩", 6.00, "64e3f2", 10, 1.00, 10.00), "scale", 0, 0.05)
        end
    end
    local cu = hunit.create({
        id = hability.ABILITY_TOKEN,
        whichPlayer = hplayer.player_passive,
        x = cj.GetUnitX(u),
        y = cj.GetUnitY(u),
    })
    cj.UnitAddAbility(cu, hability.ABILITY_SWIM)
    cj.SetUnitAbilityLevel(cu, hability.ABILITY_SWIM, 1)
    cj.IssueTargetOrder(cu, "thunderbolt", u)
    hunit.del(cu, 0.4)
    habilityCache[u].swimTimer = htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.UnitRemoveAbility(u, hability.BUFF_SWIM)
    end)
end

---沉默
hability.silent = function(u, during)
    if (habilityCache[u] == nil) then
        habilityCache[u] = {}
    end
    if (habilityCache.silentUnits == nil) then
        habilityCache.silentUnits = {}
    end
    if (habilityCache.silentTrigger == nil) then
        habilityCache.silentTrigger = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(habilityCache.silentTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
        cj.TriggerAddAction(habilityCache.silentTrigger, function()
            local u1 = cj.GetTriggerUnit()
            if (hsystem.inArray(u1, habilityCache.silentUnits)) then
                cj.IssueImmediateOrder(u1, "stop")
            end
        end)
    end
    local level = habilityCache[u].silentLevel + 1
    if (level <= 1) then
        httg.style(httg.ttg2Unit(u, "沉默", 6.00, "ee82ee", 10, 1.00, 10.00), "scale", 0, 0.2)
    else
        httg.style(httg.ttg2Unit(u, math.floor(level) .. "重沉默", 6.00, "ee82ee", 10, 1.00, 10.00), "scale", 0, 0.2)
    end
    habilityCache[u].silentLevel = level
    if (hsystem.inArray(u, habilityCache.silentUnits) == false) then
        table.insert(habilityCache.silentUnits, u)
        local eff = heffect.bindUnit("Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl", u, "head", -1)
        habilityCache[u].silentEffect = eff
    end
    htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        habilityCache[u].silentLevel = habilityCache[u].silentLevel - 1
        if (habilityCache[u].silentLevel <= 0) then
            heffect.del(habilityCache[u].silentEffect)
            if (hsystem.inArray(u, habilityCache.silentUnits)) then
                hsystem.rmArray(u, habilityCache.silentUnits)
            end
        end
    end)
end

---缴械
hability.unarm = function(u, during)
    if (habilityCache[u] == nil) then
        habilityCache[u] = {}
    end
    if (habilityCache.unarmUnits == nil) then
        habilityCache.unarmUnits = {}
    end
    if (habilityCache.unarmTrigger == nil) then
        habilityCache.unarmTrigger = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(habilityCache.unarmTrigger, EVENT_PLAYER_UNIT_ATTACKED)
        cj.TriggerAddAction(habilityCache.unarmTrigger, function()
            local u1 = cj.GetTriggerUnit()
            if (hsystem.inArray(u1, habilityCache.unarmUnits)) then
                cj.IssueImmediateOrder(u1, "stop")
            end
        end)
    end
    local level = habilityCache[u].unarmLevel + 1
    if (level <= 1) then
        httg.style(httg.ttg2Unit(u, "缴械", 6.00, "ffe4e1", 10, 1.00, 10.00), "scale", 0, 0.2)
    else
        httg.style(httg.ttg2Unit(u, math.floor(level) .. "重缴械", 6.00, "ffe4e1", 10, 1.00, 10.00), "scale", 0, 0.2)
    end
    habilityCache[u].unarmLevel = level
    if (hsystem.inArray(u, habilityCache.unarmUnits) == false) then
        table.insert(habilityCache.unarmUnits, u)
        local eff = heffect.bindUnit("Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl", u, "weapon", -1)
        habilityCache[u].unarmEffect = eff
    end
    htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        habilityCache[u].unarmLevel = habilityCache[u].unarmLevel - 1
        if (habilityCache[u].unarmLevel <= 0) then
            heffect.del(habilityCache[u].unarmEffect)
            if (hsystem.inArray(u, habilityCache.unarmUnits)) then
                hsystem.rmArray(u, habilityCache.unarmUnits)
            end
        end
    end)
end

---回避
hability.avoid = function(whichUnit)
    cj.UnitAddAbility(whichUnit, hability.ABILITY_AVOID_PLUS)
    cj.SetUnitAbilityLevel(whichUnit, hability.ABILITY_AVOID_PLUS, 2)
    cj.UnitRemoveAbility(whichUnit, hability.ABILITY_AVOID_PLUS)
    htime.setTimeout(0.00, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.UnitAddAbility(whichUnit, hability.ABILITY_AVOID_MIUNS)
        cj.SetUnitAbilityLevel(whichUnit, hability.ABILITY_AVOID_MIUNS, 2)
        cj.UnitRemoveAbility(whichUnit, hability.ABILITY_AVOID_MIUNS)
    end)
end

---0秒无敌
hability.invulnerableZero = function(whichUnit)
    if (whichUnit == nil) then
        return
    end
    cj.SetUnitInvulnerable(whichUnit, true)
    htime.setTimeout(0.00, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.SetUnitInvulnerable(whichUnit, false)
    end)
end
---无敌
hability.invulnerable = function(whichUnit, during)
    if (whichUnit == nil) then
        return
    end
    if (during < 0) then
        during = 0.00  -- 如果设置持续时间错误，则0秒无敌，跟回避效果相同
    end
    cj.SetUnitInvulnerable(whichUnit, true)
    htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.SetUnitInvulnerable(whichUnit, false)
    end)
end
---群体无敌
hability.invulnerableGroup = function(whichGroup, during)
    if (whichGroup == nil) then
        return
    end
    if (during < 0) then
        during = 0.00  -- 如果设置持续时间错误，则0秒无敌，跟回避效果相同
    end
    cj.ForGroup(whichGroup, function()
        cj.SetUnitInvulnerable(cj.GetEnumUnit(), true)
    end)
    htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.ForGroup(whichGroup, function()
            cj.SetUnitInvulnerable(cj.GetEnumUnit(), false)
        end)
    end)
end
---暂停效果
hability.pause = function(whichUnit, during, pauseColor)
    if (whichUnit == nil) then
        return
    end
    if (habilityCache[whichUnit] == nil) then
        habilityCache[whichUnit] = {}
    end
    if (during < 0) then
        during = 0.01  -- 假如没有设置时间，默认打断效果
    end
    local prevTimer = habilityCache[whichUnit].pauseTimer
    local prevTimeRemaining = 0
    if (prevTimer ~= nil) then
        prevTimeRemaining = cj.TimerGetRemaining(prevTimer)
        if (prevTimeRemaining > 0) then
            htime.delTimer(prevTimer)
            habilityCache[whichUnit].pauseTimer = nil
        else
            prevTimeRemaining = 0
        end
    end
    if (pauseColor == "black") then
        bj.SetUnitVertexColorBJ(whichUnit, 30, 30, 30, 0)
    elseif (pauseColor == "blue") then
        bj.SetUnitVertexColorBJ(whichUnit, 30, 30, 200, 0)
    elseif (pauseColor == "red") then
        bj.SetUnitVertexColorBJ(whichUnit, 200, 30, 30, 0)
    elseif (pauseColor == "green") then
        bj.SetUnitVertexColorBJ(whichUnit, 30, 200, 30, 0)
    end
    cj.SetUnitTimeScalePercent(whichUnit, 0.00)
    cj.PauseUnit(whichUnit, true)
    habilityCache[whichUnit].pauseTimer = htime.setTimeout(during + prevTimeRemaining, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.PauseUnit(whichUnit, false)
        if (string.len(pauseColor) ~= nil) then
            cj.SetUnitVertexColorBJ(whichUnit, 100, 100, 100, 0)
        end
        cj.SetUnitTimeScalePercent(whichUnit, 100.00)
    end)
end

---为单位添加效果只限技能类(一般使用物品技能<攻击之爪>模拟)一段时间
hability.addAbilityEffect = function(whichUnit, whichAbility, abilityLevel, during)
    if (whichUnit ~= nil and whichAbility ~= nil and during > 0.03) then
        cj.UnitAddAbility(whichUnit, whichAbility)
        cj.UnitMakeAbilityPermanent(whichUnit, true, whichAbility)
        if (abilityLevel > 0) then
            cj.SetUnitAbilityLevel(whichUnit, whichAbility, abilityLevel)
        end
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.UnitRemoveAbility(whichUnit, whichAbility)
        end)
    end
end

--- 自定义技能 - 对点
--[[
    bean = {
        whichPlayer,
        skillId,
        orderString,
        x,y 创建位置
        targetX,targetY 对XY时可选
        targetLoc, 对点时可选
        targetUnit, 对单位时可选
    }
]]
hability.diy = function(bean, life)
    if (bean.whichPlayer == nil or bean.skillId == nil or bean.orderString == nil) then
        return
    end
    if (bean.x == nil or bean.y == nil) then
        return
    end
    if (bean.life == nil or bean.life < 2.00) then
        life = 2.00
    end
    local token = cj.CreateUnit(bean.whichPlayer, hability.ABILITY_TOKEN, x, y, bj_UNIT_FACING)
    cj.UnitAddAbility(token, bean.skillId)
    if (bean.targetUnit ~= nil) then
        cj.IssueTargetOrderById(token, bean.orderId, bean.targetUnit)
    elseif (bean.targetX ~= nil and bean.targetY ~= nil) then
        cj.IssuePointOrder(token, bean.orderString, bean.targetX, bean.targetY)
    elseif (bean.targetLoc ~= nil) then
        cj.IssuePointOrderLoc(token, bean.orderString, bean.targetLoc)
    else
        cj.IssueImmediateOrder(token, bean.orderString)
    end
    hunit.del(token, life)
end
