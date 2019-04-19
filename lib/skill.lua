hskillCache = {}
hskill = {
    SKILL_TOKEN = hslk_global.unit_token,
    SKILL_BREAK = hslk_global.skill_break,
    SKILL_SWIM = hslk_global.skill_swim_unlimit,
    SKILL_AVOID_PLUS = hslk_global.attr.avoid.add,
    SKILL_AVOID_MIUNS = hslk_global.attr.avoid.sub,
    BUFF_SWIM = hsystem.getObjId('BPSE'),
}

---打断
-- ! 注意这个方法对中立被动无效
hskill.broken = function(u, sourceUnit, damage, percent)
    sourceUnit = sourceUnit or nil
    damage = damage or 0
    percent = percent or -1
    local cu = hunit.create({
        id = hskill.SKILL_TOKEN,
        whichPlayer = hplayer.player_passive,
        x = cj.GetUnitX(u),
        y = cj.GetUnitY(u),
    })
    cj.UnitAddAbility(cu, hskill.SKILL_BREAK)
    cj.SetUnitAbilityLevel(cu, hskill.SKILL_BREAK, 1)
    cj.IssueTargetOrder(cu, "thunderbolt", u)
    hunit.del(cu, 0.3)
    if(sourceUnit ~= nil)then
        -- @触发打断事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.broken,
            triggerUnit = sourceUnit,
            targetUnit = u,
            damage = damage,
            percent = percent,
        })
    end
    -- @触发被打断事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.beBroken,
        triggerUnit = u,
        sourceUnit = sourceUnit,
        damage = damage,
        percent = percent,
    })
end

---眩晕
-- ! 注意这个方法对中立被动无效
hskill.swim = function(u, during, sourceUnit, damage, percent)
    sourceUnit = sourceUnit or nil
    damage = damage or 0
    percent = percent or -1
    if (hskillCache[u] == nil) then
        hskillCache[u] = {}
    end
    local t = hskillCache[u].swimTimer
    if (t ~= nil and cj.TimerGetRemaining(t) > 0) then
        if (during <= cj.TimerGetRemaining(t)) then
            return
        else
            htime.delTimer(t)
            hskillCache[u].swimTimer = nil
            cj.UnitRemoveAbility(u, hskill.BUFF_SWIM)
            httg.style(httg.create2Unit(u, "劲眩", 6.00, "64e3f2", 10, 1.00, 10.00), "scale", 0, 0.05)
        end
    end
    local cu = hunit.create({
        id = hskill.SKILL_TOKEN,
        whichPlayer = hplayer.player_passive,
        x = cj.GetUnitX(u),
        y = cj.GetUnitY(u),
    })
    cj.UnitAddAbility(cu, hskill.SKILL_SWIM)
    cj.SetUnitAbilityLevel(cu, hskill.SKILL_SWIM, 1)
    cj.IssueTargetOrder(cu, "thunderbolt", u)
    hunit.del(cu, 0.4)
    hisCache[cu].isSwim = true
    if(sourceUnit ~= nil)then
        -- @触发眩晕事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.swim,
            triggerUnit = sourceUnit,
            targetUnit = u,
            damage = damage,
            percent = percent,
            during = during,
        })
    end
    -- @触发被眩晕事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.beSwim,
        triggerUnit = u,
        sourceUnit = sourceUnit,
        damage = damage,
        percent = percent,
        during = during,
    })
    hskillCache[u].swimTimer = htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.UnitRemoveAbility(u, hskill.BUFF_SWIM)
        hisCache[cu].isSwim = false
    end)
end

---沉默
hskill.silent = function(u, during, sourceUnit, damage, percent)
    sourceUnit = sourceUnit or nil
    damage = damage or 0
    percent = percent or -1
    if (hskillCache[u] == nil) then
        hskillCache[u] = {}
    end
    if (hskillCache.silentUnits == nil) then
        hskillCache.silentUnits = {}
    end
    if (hskillCache.silentTrigger == nil) then
        hskillCache.silentTrigger = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hskillCache.silentTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
        cj.TriggerAddAction(hskillCache.silentTrigger, function()
            local u1 = cj.GetTriggerUnit()
            if (hsystem.inArray(u1, hskillCache.silentUnits)) then
                cj.IssueImmediateOrder(u1, "stop")
            end
        end)
    end
    local level = hskillCache[u].silentLevel + 1
    if (level <= 1) then
        httg.style(httg.ttg2Unit(u, "沉默", 6.00, "ee82ee", 10, 1.00, 10.00), "scale", 0, 0.2)
    else
        httg.style(httg.ttg2Unit(u, math.floor(level) .. "重沉默", 6.00, "ee82ee", 10, 1.00, 10.00), "scale", 0, 0.2)
    end
    hskillCache[u].silentLevel = level
    if (hsystem.inArray(u, hskillCache.silentUnits) == false) then
        table.insert(hskillCache.silentUnits, u)
        local eff = heffect.bindUnit("Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl", u, "head", -1)
        hskillCache[u].silentEffect = eff
    end
    hisCache[u].isSilent = true
    if(sourceUnit ~= nil)then
        -- @触发沉默事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.silent,
            triggerUnit = sourceUnit,
            targetUnit = u,
            damage = damage,
            percent = percent,
            during = during,
        })
    end
    -- @触发被沉默事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.beSilent,
        triggerUnit = u,
        sourceUnit = sourceUnit,
        damage = damage,
        percent = percent,
        during = during,
    })
    htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        hskillCache[u].silentLevel = hskillCache[u].silentLevel - 1
        if (hskillCache[u].silentLevel <= 0) then
            heffect.del(hskillCache[u].silentEffect)
            if (hsystem.inArray(u, hskillCache.silentUnits)) then
                hsystem.rmArray(u, hskillCache.silentUnits)
            end
            hisCache[u].isSilent = false
        end
    end)
end

---缴械
hskill.unarm = function(u, during, sourceUnit, damage, percent)
    sourceUnit = sourceUnit or nil
    damage = damage or 0
    percent = percent or -1
    if (hskillCache[u] == nil) then
        hskillCache[u] = {}
    end
    if (hskillCache.unarmUnits == nil) then
        hskillCache.unarmUnits = {}
    end
    if (hskillCache.unarmTrigger == nil) then
        hskillCache.unarmTrigger = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hskillCache.unarmTrigger, EVENT_PLAYER_UNIT_ATTACKED)
        cj.TriggerAddAction(hskillCache.unarmTrigger, function()
            local u1 = cj.GetTriggerUnit()
            if (hsystem.inArray(u1, hskillCache.unarmUnits)) then
                cj.IssueImmediateOrder(u1, "stop")
            end
        end)
    end
    local level = hskillCache[u].unarmLevel + 1
    if (level <= 1) then
        httg.style(httg.ttg2Unit(u, "缴械", 6.00, "ffe4e1", 10, 1.00, 10.00), "scale", 0, 0.2)
    else
        httg.style(httg.ttg2Unit(u, math.floor(level) .. "重缴械", 6.00, "ffe4e1", 10, 1.00, 10.00), "scale", 0, 0.2)
    end
    hskillCache[u].unarmLevel = level
    if (hsystem.inArray(u, hskillCache.unarmUnits) == false) then
        table.insert(hskillCache.unarmUnits, u)
        local eff = heffect.bindUnit("Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdl", u, "weapon", -1)
        hskillCache[u].unarmEffect = eff
    end
    hisCache[u].isUnArm = true
    if(sourceUnit ~= nil)then
        -- @触发缴械事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.unarm,
            triggerUnit = sourceUnit,
            targetUnit = u,
            damage = damage,
            percent = percent,
            during = during,
        })
    end
    -- @触发被缴械事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.beUnarm,
        triggerUnit = u,
        sourceUnit = sourceUnit,
        damage = damage,
        percent = percent,
        during = during,
    })
    htime.setTimeout(during, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        hskillCache[u].unarmLevel = hskillCache[u].unarmLevel - 1
        if (hskillCache[u].unarmLevel <= 0) then
            heffect.del(hskillCache[u].unarmEffect)
            if (hsystem.inArray(u, hskillCache.unarmUnits)) then
                hsystem.rmArray(u, hskillCache.unarmUnits)
            end
            hisCache[u].isUnArm = false
        end
    end)
end

---回避
hskill.avoid = function(whichUnit)
    cj.UnitAddAbility(whichUnit, hskill.SKILL_AVOID_PLUS)
    cj.SetUnitAbilityLevel(whichUnit, hskill.SKILL_AVOID_PLUS, 2)
    cj.UnitRemoveAbility(whichUnit, hskill.SKILL_AVOID_PLUS)
    htime.setTimeout(0.00, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.UnitAddAbility(whichUnit, hskill.SKILL_AVOID_MIUNS)
        cj.SetUnitAbilityLevel(whichUnit, hskill.SKILL_AVOID_MIUNS, 2)
        cj.UnitRemoveAbility(whichUnit, hskill.SKILL_AVOID_MIUNS)
    end)
end

---0秒无敌
hskill.invulnerableZero = function(whichUnit)
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
hskill.invulnerable = function(whichUnit, during)
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
hskill.invulnerableGroup = function(whichGroup, during)
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
hskill.pause = function(whichUnit, during, pauseColor)
    if (whichUnit == nil) then
        return
    end
    if (hskillCache[whichUnit] == nil) then
        hskillCache[whichUnit] = {}
    end
    if (during < 0) then
        during = 0.01  -- 假如没有设置时间，默认打断效果
    end
    local prevTimer = hskillCache[whichUnit].pauseTimer
    local prevTimeRemaining = 0
    if (prevTimer ~= nil) then
        prevTimeRemaining = cj.TimerGetRemaining(prevTimer)
        if (prevTimeRemaining > 0) then
            htime.delTimer(prevTimer)
            hskillCache[whichUnit].pauseTimer = nil
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
    hskillCache[whichUnit].pauseTimer = htime.setTimeout(during + prevTimeRemaining, function(t, td)
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
hskill.addAbilityEffect = function(whichUnit, whichAbility, abilityLevel, during)
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
hskill.diy = function(bean, life)
    if (bean.whichPlayer == nil or bean.skillId == nil or bean.orderString == nil) then
        return
    end
    if (bean.x == nil or bean.y == nil) then
        return
    end
    if (bean.life == nil or bean.life < 2.00) then
        life = 2.00
    end
    local token = cj.CreateUnit(bean.whichPlayer, hskill.SKILL_TOKEN, x, y, bj_UNIT_FACING)
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
