hskillCache = {}
hskill = {
    SKILL_TOKEN = hslk_global.unit_token,
    SKILL_BREAK = hslk_global.skill_break,
    SKILL_SWIM = hslk_global.skill_swim_unlimit,
    SKILL_AVOID_PLUS = hslk_global.attr.avoid.add,
    SKILL_AVOID_MIUNS = hslk_global.attr.avoid.sub,
    BUFF_SWIM = hsystem.getObjId('BPSE'),
}

--- 造成伤害
hskill.damage = function(bean)
    -- 文本显示
    bean.realDamageString = bean.realDamageString or ''
    bean.realDamageStringColor = bean.realDamageStringColor or nil
    httg.style(httg.create2Unit(
            bean.toUnit,
            bean.realDamageString .. math.floor(bean.realDamage),
            6.00,
            bean.realDamageStringColor,
            10,
            1.1,
            11.00
    ), "toggle", -0.05, 0)
    hevent.setLastDamageUnit(bean.toUnit, bean.fromUnit)
    hplayer.addDamage(cj.GetOwningPlayer(bean.fromUnit), bean.realDamage)
    hplayer.addBeDamage(cj.GetOwningPlayer(bean.toUnit), bean.realDamage)
    hunit.subLife(bean.toUnit, bean.realDamage)
    if (type(bean.huntEff) == 'string' and string.len(bean.huntEff) > 0) then
        heffect.toXY(bean.huntEff, cj.GetUnitX(bean.toUnit), cj.GetUnitY(bean.toUnit), 0)
    end
    -- @触发伤害事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.damage,
        triggerUnit = bean.fromUnit,
        targetUnit = bean.toUnit,
        sourceUnit = bean.fromUnit,
        damage = bean.damage,
        realDamage = bean.realDamage,
        damageKind = bean.huntKind,
        damageType = bean.huntType,
    })
    -- @触发被伤害事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.beDamage,
        triggerUnit = bean.toUnit,
        sourceUnit = bean.fromUnit,
        damage = bean.damage,
        realDamage = bean.realDamage,
        damageKind = bean.huntKind,
        damageType = bean.huntType,
    })
    if (bean.huntKind == "attack") then
        -- @触发攻击事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.attack,
            triggerUnit = bean.fromUnit,
            attacker = bean.fromUnit,
            targetUnit = bean.toUnit,
            damage = bean.damage,
            realDamage = bean.realDamage,
            damageKind = bean.huntKind,
            damageType = bean.huntType,
        })
        -- @触发被攻击事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.beAttack,
            triggerUnit = bean.fromUnit,
            attacker = bean.fromUnit,
            targetUnit = bean.toUnit,
            damage = bean.damage,
            realDamage = bean.realDamage,
            damageKind = bean.huntKind,
            damageType = bean.huntType,
        })
    end
end

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
    if (sourceUnit ~= nil) then
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
    if (sourceUnit ~= nil) then
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
    if (sourceUnit ~= nil) then
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
    if (sourceUnit ~= nil) then
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
hskill.modelEffect = function(whichUnit, whichAbility, abilityLevel, during)
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

--[[
    闪电链
    codename 闪电效果类型 详情查看 hlightning
    qty 传递单位数
    change 增减率 大于 -1 小于 1
    isRepeat 是否允许同一个单位重复打击（临近2次不会同一个）
    bean bean
]]
hskill.lightningChain = function(codename, qty, change, range, isRepeat, bean)
    qty = qty - 1
    range = range or 400
    if (qty < 0) then
        qty = 0
    end
    if (bean.index == nil) then
        bean.index = 1
    else
        bean.index = bean.index + 1
    end
    hlightning.unit2unit(codename, bean.fromUnit, bean.toUnit, 0.2 * qty)
    if (bean.model ~= nil) then
        heffect.toUnit(bean.model, bean.toUnit, "origin", 0.5)
    end
    hskill.damage({
        fromUnit = bean.fromUnit,
        toUnit = bean.toUnit,
        damage = bean.damage,
        realDamage = bean.realDamage,
        huntKind = "special",
        huntType = { "magic", "thunder" },
    })
    -- @触发被闪电链事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.beLightningChain,
        triggerUnit = bean.toUnit,
        sourceUnit = bean.fromUnit,
        damage = bean.damage,
        range = range,
        index = bean.index,
    })
    if (qty > 0) then
        if (isRepeat ~= true) then
            if (bean.repeatGroup == nil) then
                bean.repeatGroup = cj.CreateGroup()
            end
            cj.GroupAddUnit(bean.repeatGroup, bean.toUnit)
        end
        local g = hgroup.createByUnit(bean.toUnit, range, function()
            local flag = true
            if (his.death(cj.GetFilterUnit())) then
                flag = false
            end
            if (his.ally(cj.GetFilterUnit(), bean.fromUnit)) then
                flag = false
            end
            if (his.isBuilding(cj.GetFilterUnit())) then
                flag = false
            end
            if (bean.toUnit == cj.GetFilterUnit()) then
                flag = false
            end
            if (isRepeat ~= true and hgroup.isIn(bean.repeatGroup, cj.GetFilterUnit())) then
                flag = false
            end
            return flag
        end)
        if (hgroup.isEmpty(g)) then
            return
        end
        bean.toUnit = cj.FirstOfGroup(g)
        bean.damage = bean.damage * (1 + change)
        cj.GroupClear(g)
        cj.DestroyGroup(g)
        htime.setTimeout(0.35, nil, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            hskill.lightningChain(codename, qty, change, range, isRepeat, bean)
        end)
    else
        if (bean.repeatGroup ~= nil) then
            cj.GroupClear(bean.repeatGroup)
            cj.DestroyGroup(bean.repeatGroup)
        end
    end
end

--[[
    变身[参考 h-lua变身技能模板]
    * modelFrom 技能模板 参考 h-lua SLK
    * modelTo 技能模板 参考 h-lua SLK
]]
hskill.shapeshift = function(u, during, modelFrom, modelTo, eff, attrData)
    heffect.toUnit(eff, u, 1.5)
    UnitAddAbility(u, modelTo)
    UnitRemoveAbility(u, modelTo)
    hattr.reRegister(u)
    htime.setTimeout(during, nil, function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        heffect.toUnit(eff, u, 1.5)
        UnitAddAbility(u, modelFrom)
        UnitRemoveAbility(u, modelFrom)
        hattr.reRegister(u)
    end)
    -- 根据data影响属性
    hattr.set(u, during, attrData)
end

--[[
    击飞
    distance 击退距离
    high 击飞高度
]]
hskill.crackFly = function(distance, high, during, bean)
    if (bean.fromUnit == nil or bean.toUnit == nil) then
        return
    end
    -- 不二次击飞
    if (hisCache[bean.toUnit].isCrackFly == true) then
        return
    end
    hisCache[bean.toUnit].isCrackFly = true
    if (during < 0.5) then
        during = 0.5
    end
    -- 镜头放大模式下，距离缩小一半
    if (hcamera.getModel(cj.GetOwningPlayer(bean.toUnit)) == "zoomin") then
        distance = distance * 0.5
        high = high * 0.5
    end
    hskill.unarm(bean.toUnit, during, nil, 0, 0)
    hskill.silent(bean.toUnit, during, nil, 0, 0)
    hattr.set(bean.toUnit, during, {
        move = '-1044'
    })
    hunit.setCanFly(bean.toUnit)
    cj.SetUnitPathing(bean.toUnit, false)
    local originHigh = cj.GetUnitFlyHeight(bean.toUnit)
    local originFacing = hunit.getFacing(bean.toUnit)
    local originDeg = hlogic.getDegBetweenUnit(bean.fromUnit, bean.toUnit)
    local cost = 0
    -- @触发被击飞事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.beCrackFly,
        triggerUnit = bean.toUnit,
        sourceUnit = bean.fromUnit,
        damage = bean.damage,
        high = high,
        distance = distance,
    })
    htime.setInterval(0.05, nil, function(t, td)
        local xy = 0
        local z = 0
        local timerSetTime = htime.getSetTime(t)
        if (cost > during) then
            hskill.damage({
                fromUnit = bean.fromUnit,
                toUnit = bean.toUnit,
                damage = bean.damage,
                realDamage = bean.damage,
                huntEff = bean.huntEff,
                huntKind = bean.huntKind,
                huntType = bean.huntType,
            })
            cj.SetUnitFlyHeight(bean.toUnit, originHigh, 10000)
            cj.SetUnitPathing(bean.toUnit, true)
            hisCache[bean.toUnit].isCrackFly = false
            if (his.water(bean.toUnit) == true) then
                -- 如果是水面，创建水花
                heffect.toUnit("Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl", bean.toUnit, 0)
            else
                -- 如果是地面，创建沙尘
                heffect.toUnit("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl", bean.toUnit, 0)
            end
            htime.delDialog(td)
            htime.delTimer(t)
            return
        end
        cost = cost + timerSetTime
        if (cost < during * 0.35) then
            xy = distance / (during * 0.5 / timerSetTime)
            z = high / (during * 0.35 / timerSetTime)
            if (xy > 0) then
                local pxy = hlogic.polarProjection(cj.GetUnitX(bean.toUnit), cj.GetUnitY(bean.toUnit), xy, originDeg)
                cj.SetUnitFacing(bean.toUnit, originFacing)
                cj.SetUnitPosition(bean.toUnit, pxy.x, pxy.y)
            end
            if (z > 0) then
                cj.SetUnitFlyHeight(bean.toUnit, cj.GetUnitFlyHeight(bean.toUnit) + z, z / timerSetTime)
            end
        else
            xy = distance / (during * 0.5 / timerSetTime)
            z = high / (during * 0.65 / timerSetTime)
            if (xy > 0) then
                local pxy = hlogic.polarProjection(cj.GetUnitX(bean.toUnit), cj.GetUnitY(bean.toUnit), xy, originDeg)
                cj.SetUnitFacing(bean.toUnit, originFacing)
                cj.SetUnitPosition(bean.toUnit, pxy.x, pxy.y)
            end
            if (z > 0) then
                cj.SetUnitFlyHeight(bean.toUnit, cj.GetUnitFlyHeight(bean.toUnit) - z, z / timerSetTime)
            end
        end
    end)
end

--[[
    剃
    mover, 移动的单位
    x, y, 目标XY坐标
    speed, 速度
    meff, 移动特效
    range, 伤害范围
    isRepeat, 是否允许重复伤害
    bean 伤害bean
]]
hskill.leap = function(mover, targetX, targetY, speed, meff, range, isRepeat, bean)
    local lock_var_period = 0.02
    local repeatGroup
    if (mover == nil or targetX == nil or targetY == nil) then
        return
    end
    if (isRepeat == false) then
        repeatGroup = cj.CreateGroup()
    else
        repeatGroup = nil
    end
    if (speed > 150) then
        speed = 150 -- 最大速度
    elseif (speed <= 1) then
        speed = 1 -- 最小速度
    end
    cj.SetUnitInvulnerable(mover, true)
    cj.SetUnitPathing(mover, false)
    local duringInc = 0
    htime.setInterval(lock_var_period, nil, function(t, td)
        duringInc = duringInc + cj.TimerGetTimeout(t)
        local x = cj.GetUnitX(mover)
        local y = cj.GetUnitY(mover)
        local hxy = hlogic.polarProjection(x, y, speed, hlogic.getDegBetweenXY(x, y, targetX, targetY))
        cj.SetUnitPosition(mover, hxy.x, hxy.y)
        if (meff ~= nil) then
            heffect.toXY(meff, x, y, 0.5)
        end
        if (bean.damage > 0) then
            local g = hgroup.createByUnit(mover, range, function()
                local flag = true
                if (his.death(cj.GetFilterUnit())) then
                    flag = false
                end
                if (his.ally(cj.GetFilterUnit(), bean.fromUnit)) then
                    flag = false
                end
                if (his.isBuilding(cj.GetFilterUnit())) then
                    flag = false
                end
                if (isRepeat ~= true and hgroup.isIn(repeatGroup, cj.GetFilterUnit())) then
                    flag = false
                end
                return flag
            end)
            cj.ForGroup(g, function()
                hskill.damage({
                    damage = bean.damage,
                    fromUnit = bean.fromUnit,
                    toUnit = cj.GetEnumUnit(),
                    huntEff = bean.huntEff,
                    huntKind = bean.huntKind,
                    huntType = bean.huntType,
                })
            end)
            cj.GroupClear(g)
            cj.DestroyGroup(g)
        end
        local distance = hlogic.getDegBetweenXY(x, y, targetX, targetY)
        if (distance < speed or distance <= 0 or speed <= 0 or his.death(mover) == true or duringInc > 6) then
            htime.delDialog(td)
            htime.delTimer(t)
            cj.SetUnitInvulnerable(mover, false)
            cj.SetUnitPathing(mover, true)
            cj.SetUnitPosition(mover, targetX, targetY)
            cj.SetUnitVertexColorBJ(mover, 100, 100, 100, 0)
            if (repeatGroup ~= nil) then
                cj.GroupClear(repeatGroup)
                cj.DestroyGroup(repeatGroup)
            end
        end
    end)
end

