
--todo 时钟初始化
-- 全局计时器
cj.TimerStart(cj.CreateTimer(), 1.00, true, htime.clock)

--todo 属性初始化
-- 单位受伤
local triggerBeHunt = cj.CreateTrigger()
cj.TriggerAddAction(triggerBeHunt, function()
    local fromUnit = cj.GetEventDamageSource()
    local toUnit = cj.GetTriggerUnit()
    local damage = cj.GetEventDamage()
    local oldLife = hunit.getLife(toUnit)
    if (damage > 0.125) then
        hattr.set(toUnit, 0, { life = '+' .. damage })
        htime.setTimeout(0, nil, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            hattr.set(toUnit, 0, { life = '-' .. damage })
            hunit.setLife(toUnit, oldLife)
            hattr.huntUnit({
                fromUnit = fromUnit,
                toUnit = toUnit,
                damage = damage,
                huntKind = "attack",
            })
        end)
    end
end)
-- 单位死亡
local triggerDeath = cj.CreateTrigger()
cj.TriggerAddAction(triggerDeath, function()
    local u = cj.GetTriggerUnit()
    local killer = hevent.getLastDamageUnit(u)
    hplayer.addKill(GetOwningPlayer(killer), 1)
    -- @触发死亡事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.dead,
        triggerUnit = u,
        killer = killer
    })
    -- @触发击杀事件
    hevent.triggerEvent({
        triggerKey = heventKeyMap.kill,
        killer = killer,
        triggerUnit = killer,
        targetUnit = u
    })
end)
-- 单位进入区域注册
local triggerRegIn = cj.CreateTrigger()
bj.TriggerRegisterEnterRectSimple(triggerRegIn, bj.GetPlayableMapRect())
cj.TriggerAddAction(triggerRegIn, function()
    local u = cj.GetTriggerUnit()
    if (cj.GetUnitAbilityLevel(u, 'Aloc') > 0) then
        -- 蝗虫不做某些处理
        return
    end
    -- 排除单位类型
    local uid = cj.GetUnitTypeId(u)
    if (uid == hslk_global.unit_token
            or uid == hslk_global.unit_hero_tavern_token
            or uid == hslk_global.unit_hero_death_token
            or uid == hslk_global.unit_hero_tavern
    ) then
        return
    end
    -- 注册事件
    if (hRuntime.attribute[u] == nil) then
        hattr.registerAll(u)
        cj.TriggerRegisterUnitEvent(triggerBeHunt, u, EVENT_UNIT_DAMAGED)
        cj.TriggerRegisterUnitEvent(triggerDeath, u, EVENT_UNIT_DEATH)
        -- 拥有物品栏的单位绑定物品处理
        if (his.hasSlot(u)) then
            hitem.initUnit(u)
        end
        -- 触发注册事件(全局)
        hevent.triggerEvent({
            triggerKey = heventKeyMap.register,
            triggerHandle = hevent.defaultHandle,
            triggerUnit = u,
        })
    end
end)

-- 计时器
-- 生命魔法恢复
htime.setInterval(0.50, nil, function(t, td)
    local period = cj.TimerGetTimeout(t)
    for k, u in pairs(hRuntime.attributeGroup.life_back) do
        if (his.alive(u)) then
            if (hattr.get(u, 'life_back') ~= 0) then
                hunit.addLife(u, hattr.get(u, 'life_back') * period)
            end
        end
    end
    for k, u in pairs(hRuntime.attributeGroup.mana_back) do
        if (his.alive(u)) then
            if (hattr.get(u, 'mana_back') ~= 0) then
                hunit.addMana(u, hattr.get(u, 'mana_back') * period)
            end
        end
    end
    --- 源力只有在没受伤判定的情况下才会有效
    for k, u in pairs(hRuntime.attributeGroup.life_source) do
        if (his.alive(u) and hunit.getLifePercent(u) < hplayer.getLifeSourceRatio(cj.GetOwningPlayer(u))) then
            if (hattr.get(u, 'be_hunting') == false) then
                if (hattr.get(u, 'life_source_current') > 0) then
                    local fill = hunit.getMaxLife(u) - hunit.getCurLife(u)
                    if (fill > hattr.get(u, 'life_source_current')) then
                        fill = hattr.get(u, 'life_source_current')
                    end
                    hattr.set(u, 0, { life_source_current = '-' .. fill })
                    hunit.addLife(u, fill)
                    httg.style(
                            httg.ttg2Unit(u, "命源+" .. fill, 6.00, "bce43a", 10, 1.00, 10.00),
                            "scale",
                            0,
                            0.2
                    )
                end
            end
        end
    end
    for k, u in pairs(hRuntime.attributeGroup.mana_source) do
        if (his.alive(u) and hunit.getManaPercent(u) < hplayer.getManaSourceRatio(cj.GetOwningPlayer(u))) then
            if (hattr.get(u, 'be_hunting') == false) then
                if (hattr.get(u, 'mana_source_current') > 0) then
                    local fill = hunit.getMaxLife(u) - hunit.getCurMana(u)
                    if (fill > hattr.get(u, 'mana_source_current')) then
                        fill = hattr.get(u, 'mana_source_current')
                    end
                    hattr.set(u, 0, { mana_source_current = '-' .. fill })
                    hunit.addMana(u, fill)
                    httg.style(
                            httg.ttg2Unit(u, "魔源+" .. fill, 6.00, "93d3f1", 10, 1.00, 10.00),
                            "scale",
                            0,
                            0.2
                    )
                end
            end
        end
    end
end)
-- 硬直恢复(3秒内没收到伤害后,每1秒恢复1%)
htime.setInterval(1.00, nil, function(t, td)
    for k, u in pairs(hRuntime.attributeGroup.punish_current) do
        if (his.alive(u) and hattr.get(u, 'punish') > 0 and hattr.get(u, 'punish_current') < hattr.get(u, 'punish')) then
            if (hattr.get(u, 'be_hunting') == false) then
                hattr.set(u, 0, { punish_current = '+' .. (hattr.get(u, 'punish') * 0.01) })
            end
        end
    end
end)
-- 源恢复
htime.setInterval(15.00, nil, function(t, td)
    for k, u in pairs(hRuntime.attributeGroup.life_source) do
        if (his.alive(u)) then
            hattr.set(u, 0, { life_source_current = '+100' })
        end
    end
    for k, u in pairs(hRuntime.attributeGroup.mana_source) do
        if (his.alive(u)) then
            hattr.set(u, 0, { mana_source_current = '+100' })
        end
    end
end)