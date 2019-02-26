heventGlobalTgr = {}
heventTgr = {}
heventData = {}
heventKeyMap = {
    attackDetect = "attackDetect",
    attackGetTarget = "attackGetTarget",
    attackReady = "attackReady",
    beAttackReady = "beAttackReady",
    attack = "attack",
    beAttack = "beAttack",
    skillStudy = "skillStudy",
    skillReady = "skillReady",
    skillStart = "skillStart",
    skillHappen = "skillHappen",
    skillStop = "skillStop",
    skillOver = "skillOver",
    itemUsed = "itemUsed",
    itemSell = "itemSell",
    itemDrop = "itemDrop",
    itemPawn = "itemPawn",
    itemGet = "itemGet",
    itemDestroy = "itemDestroy",
    itemMix = "itemMix",
    itemSeparate = "itemSeparate",
    damage = "damage",
    beDamage = "beDamage",
    avoid = "avoid",
    beAvoid = "beAvoid",
    breakArmor = "breakArmor",
    beBreakArmor = "beBreakArmor",
    swim = "swim",
    beSwim = "beSwim",
    rebound = "rebound",
    noAvoid = "noAvoid",
    beNoAvoid = "beNoAvoid",
    knocking = "knocking",
    beKnocking = "beKnocking",
    violence = "violence",
    beViolence = "beViolence",
    spilt = "spilt",
    beSpilt = "beSpilt",
    hemophagia = "hemophagia",
    beHemophagia = "beHemophagia",
    skillHemophagia = "skillHemophagia",
    beSkillHemophagia = "beSkillHemophagia",
    punish = "punish",
    dead = "dead",
    kill = "kill",
    reborn = "reborn",
    levelUp = "levelUp",
    summon = "summon",
    enterUnitRange = "enterUnitRange",
    enterRect = "enterRect",
    leaveRect = "leaveRect",
    chat = "chat",
    esc = "esc",
    selection = "selection",
    unSelection = "unSelection",
    upgradeStart = "upgradeStart",
    upgradeCancel = "upgradeCancel",
    upgradeFinish = "upgradeFinish",
    constructStart = "constructStart",
    constructCancel = "constructCancel",
    constructFinish = "constructFinish",
    register = "register",
    pickHero = "pickHero",
}
hevent = {
    defaultHandle = cj.Player(PLAYER_NEUTRAL_PASSIVE),
    -- set最后一位伤害的单位
    setLastDamageUnit = function(which, last)
        heventData[which].lastDamageUnit = last
    end,
    -- get最后一位伤害的单位
    getLastDamageUnit = function(which)
        return heventData[which].lastDamageUnit or nil
    end,
}
-- 触发事件（通用）
hevent.triggerEvent = function(bean)
    if (bean.triggerKey == nil) then
        return
    end
    if (bean.triggerHandle == nil and bean.triggerPlayer ~= nil) then
        bean.triggerHandle = bean.triggerPlayer
    end
    if (bean.triggerHandle == nil and bean.triggerRect ~= nil) then
        bean.triggerHandle = bean.triggerRect
    end
    if (bean.triggerHandle == nil and bean.triggerUnit ~= nil) then
        bean.triggerHandle = bean.triggerUnit
    end
    if (bean.triggerHandle ~= nil) then
        if (heventData[bean.triggerHandle] == nil) then
            return
        end
        if (heventData[bean.triggerHandle].trigger == nil) then
            return
        end
        if (heventData[bean.triggerHandle].trigger[bean.triggerKey] == nil) then
            return
        end
        local triggers = heventData[bean.triggerHandle].trigger[bean.triggerKey]
        if (triggers == nil or #triggers == 0) then
            return
        end
        for k, tempTgr in pairs(triggers) do
            if (bean.triggerUnit ~= nil) then
                heventTgr[tempTgr].triggerUnit = bean.triggerUnit
            end
            if (bean.triggerEnterUnit ~= nil) then
                heventTgr[tempTgr].triggerEnterUnit = bean.triggerEnterUnit
            end
            if (bean.triggerRect ~= nil) then
                heventTgr[tempTgr].triggerRect = bean.triggerRect
            end
            if (bean.triggerItem ~= nil) then
                heventTgr[tempTgr].triggerItem = bean.triggerItem
            end
            if (bean.triggerPlayer ~= nil) then
                heventTgr[tempTgr].triggerPlayer = bean.triggerPlayer
            end
            if (bean.triggerString ~= nil) then
                heventTgr[tempTgr].triggerString = bean.triggerString
            end
            if (bean.triggerStringMatched ~= nil) then
                heventTgr[tempTgr].triggerStringMatched = bean.triggerStringMatched
            end
            if (bean.triggerSkill ~= nil) then
                heventTgr[tempTgr].triggerSkill = bean.triggerSkill
            end
            if (bean.sourceUnit ~= nil) then
                heventTgr[tempTgr].sourceUnit = bean.sourceUnit
            end
            if (bean.targetUnit ~= nil) then
                heventTgr[tempTgr].targetUnit = bean.targetUnit
            end
            if (bean.targetLoc ~= nil) then
                heventTgr[tempTgr].targetLoc = bean.targetLoc
            end
            if (bean.attacker ~= nil) then
                heventTgr[tempTgr].attacker = bean.attacker
            end
            if (bean.killer ~= nil) then
                heventTgr[tempTgr].killer = bean.killer
            end
            if (bean.damage ~= nil) then
                heventTgr[tempTgr].damage = bean.damage
            end
            if (bean.realDamage ~= nil) then
                heventTgr[tempTgr].realDamage = bean.realDamage
            end
            if (bean.id ~= nil) then
                heventTgr[tempTgr].id = bean.id
            end
            if (bean.range ~= nil) then
                heventTgr[tempTgr].range = bean.range
            end
            if (bean.value ~= nil) then
                heventTgr[tempTgr].value = bean.value
            end
            if (bean.value2 ~= nil) then
                heventTgr[tempTgr].value2 = bean.value2
            end
            if (bean.value3 ~= nil) then
                heventTgr[tempTgr].value3 = bean.value3
            end
            if (bean.value4 ~= nil) then
                heventTgr[tempTgr].value4 = bean.value4
            end
            if (bean.during ~= nil) then
                heventTgr[tempTgr].during = bean.during
            end
            if (bean.damageKind ~= nil) then
                heventTgr[tempTgr].damageKind = bean.damageKind
            end
            if (bean.damageType ~= nil) then
                heventTgr[tempTgr].damageType = bean.damageType
            end
            if (bean.breakType ~= nil) then
                heventTgr[tempTgr].breakType = bean.breakType
            end
            if (bean.type ~= nil) then
                heventTgr[tempTgr].type = bean.type
            end
            if (bean.isNoAvoid ~= false) then
                heventTgr[tempTgr].isNoAvoid = bean.isNoAvoid
            end
            cj.TriggerExecute(tempTgr)
        end
    end
end
-- 构建事件（通用）
hevent.onEventByHandleDefaultTrigger = function(evtKey, whichHandle, action, defaultTrigger)
    if (string.len(evtKey) < 1 or whichHandle == nil or action == nil) then
        return
    end
    if (heventData[whichHandle] == nil) then
        heventData[whichHandle] = {}
    end
    if (heventData[whichHandle].trigger == nil) then
        heventData[whichHandle].trigger = {}
    end
    if (heventData[whichHandle].trigger[evtKey] == nil) then
        heventData[whichHandle].trigger[evtKey] = {}
    end
    table.insert(heventData[whichHandle].trigger[evtKey], defaultTrigger)
    return defaultTrigger
end
hevent.onEventByHandle = function(evtKey, whichHandle, action)
    local tg = cj.CreateTrigger()
    cj.TriggerAddAction(tg, action)
    return hevent.onEventByHandleDefaultTrigger(evtKey, whichHandle, action, tg)
end

-- 获取 triggerUnit 单位
hevent.getTriggerUnit = function()
    return heventTgr[cj.GetTriggeringTrigger()].triggerUnit or nil
end
-- 获取 triggerEnterUnit 单位
hevent.getTriggerEnterUnit = function()
    return heventTgr[cj.GetTriggeringTrigger()].triggerEnterUnit or nil
end
-- 获取 triggerRect 区域
hevent.getTriggerRect = function()
    return heventTgr[cj.GetTriggeringTrigger()].triggerRect or nil
end
-- 获取 triggerItem 物品
hevent.getTriggerItem = function()
    return heventTgr[cj.GetTriggeringTrigger()].triggerItem or nil
end
-- 获取 triggerPlayer 玩家
hevent.getTriggerPlayer = function()
    return heventTgr[cj.GetTriggeringTrigger()].triggerPlayer or nil
end
-- 获取 triggerString 字符串
hevent.getTriggerString = function()
    return heventTgr[cj.GetTriggeringTrigger()].triggerString or nil
end
-- 获取 triggerStringMatched 字符串
hevent.getTriggerStringMatched = function()
    return heventTgr[cj.GetTriggeringTrigger()].triggerStringMatched or nil
end
-- 获取 triggerSkill 整型
hevent.getTriggerSkill = function()
    return heventTgr[cj.GetTriggeringTrigger()].triggerSkill or nil
end
-- 获取 sourceUnit 单位
hevent.getSourceUnit = function()
    return heventTgr[cj.GetTriggeringTrigger()].sourceUnit or nil
end
-- 获取 targetUnit 单位
hevent.getTargetUnit = function()
    return heventTgr[cj.GetTriggeringTrigger()].targetUnit or nil
end
-- 获取 targetLoc 点
hevent.getTargetLoc = function()
    return heventTgr[cj.GetTriggeringTrigger()].targetLoc or nil
end
-- 获取 attacker 单位
hevent.getAttacker = function()
    return heventTgr[cj.GetTriggeringTrigger()].attacker or nil
end
-- 获取 killer 单位
hevent.getKiller = function()
    return heventTgr[cj.GetTriggeringTrigger()].killer or nil
end
-- 获取 damage 实数
hevent.getDamage = function()
    return heventTgr[cj.GetTriggeringTrigger()].damage or nil
end
-- 获取 realDamage 实数
hevent.getRealDamage = function()
    return heventTgr[cj.GetTriggeringTrigger()].realDamage or nil
end
-- 获取 id 整型
hevent.getId = function()
    return heventTgr[cj.GetTriggeringTrigger()].id or nil
end
-- 获取 range 实数
hevent.getRange = function()
    return heventTgr[cj.GetTriggeringTrigger()].range or nil
end
-- 获取 value 实数
hevent.getValue = function()
    return heventTgr[cj.GetTriggeringTrigger()].value or nil
end
-- 获取 value2 实数
hevent.getValue2 = function()
    return heventTgr[cj.GetTriggeringTrigger()].value2 or nil
end
-- 获取 value3 实数
hevent.getValue3 = function()
    return heventTgr[cj.GetTriggeringTrigger()].value3 or nil
end
-- 获取 value4 实数
hevent.getValue4 = function()
    return heventTgr[cj.GetTriggeringTrigger()].value4 or nil
end
-- 获取 during 实数
hevent.getDuring = function()
    return heventTgr[cj.GetTriggeringTrigger()].during or nil
end
-- 获取 damageKind 字符串
hevent.getDamageKind = function()
    return heventTgr[cj.GetTriggeringTrigger()].damageKind or nil
end
-- 获取 damageType 字符串
hevent.getDamageType = function()
    return heventTgr[cj.GetTriggeringTrigger()].damageType or nil
end
-- 获取 breakType 字符串
hevent.getBreakType = function()
    return heventTgr[cj.GetTriggeringTrigger()].breakType or nil
end
-- 获取 type 字符串
hevent.getType = function()
    return heventTgr[cj.GetTriggeringTrigger()].type or nil
end
-- 获取 isNoAvoid 布尔值
hevent.getIsNoAvoid = function()
    return heventTgr[cj.GetTriggeringTrigger()].isNoAvoid or nil
end

--- 模拟BJ函数 TriggerRegisterAnyUnitEventBJ
hevent.TriggerRegisterAnyUnitEvent = function(trig, whichEvent)
    for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
        cj.TriggerRegisterPlayerUnitEvent(trig, cj.Player(i - 1), whichEvent, nil)
    end
end
--- 模拟BJ函数 TriggerRegisterPlayerSelectionEvent
hevent.TriggerRegisterPlayerSelectionEvent = function(trig, whichPlayer, selected)
    if (selected) then
        return cj.TriggerRegisterPlayerUnitEvent(trig, whichPlayer, EVENT_PLAYER_UNIT_SELECTED, nil)
    else
        return cj.TriggerRegisterPlayerUnitEvent(trig, whichPlayer, EVENT_PLAYER_UNIT_DESELECTED, nil)
    end
end


-- todo - 注意到攻击目标
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取被注意/目标单位
hevent.onAttackDetect = function(whichUnit, action)
    local evtKey = heventKeyMap.attackDetect
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                targetUnit = cj.GetEventTargetUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(heventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_ACQUIRED_TARGET)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 获取攻击目标
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取被获取/目标单位
hevent.onAttackGetTarget = function(whichUnit, action)
    local evtKey = heventKeyMap.attackGetTarget
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                targetUnit = cj.GetEventTargetUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(heventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_TARGET_IN_RANGE)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 准备攻击
-- @getTriggerUnit 获取攻击单位
-- @getTargetUnit 获取被攻击单位
-- @getAttacker 获取攻击单位
hevent.onAttackReadyAction = function(whichUnit, action)
    local evtKey = heventKeyMap.attackReady
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_ATTACKED)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetAttacker(),
                targetUnit = cj.GetTriggerUnit(),
                attacker = cj.GetAttacker(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 准备被攻击
-- @getTriggerUnit 获取被攻击单位
-- @getTargetUnit 获取攻击单位
-- @getAttacker 获取攻击单位
hevent.onBeAttackReady = function(whichUnit, action)
    local evtKey = heventKeyMap.beAttackReady
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_ATTACKED)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                targetUnit = cj.GetAttacker(),
                attacker = cj.GetAttacker(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 造成攻击
-- @getTriggerUnit 获取攻击来源
-- @getTargetUnit 获取被攻击单位
-- @getAttacker 获取攻击来源
-- @getDamage 获取初始伤害
-- @getRealDamage 获取实际伤害
-- @getDamageKind 获取伤害方式
-- @getDamageType 获取伤害类型
hevent.onAttack = function(whichUnit, action)
    local evtKey = heventKeyMap.attack
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 承受攻击
-- @getTriggerUnit 获取被攻击单位
-- @getAttacker 获取攻击来源
-- @getDamage 获取初始伤害
-- @getRealDamage 获取实际伤害
-- @getDamageKind 获取伤害方式
-- @getDamageType 获取伤害类型
hevent.onBeAttack = function(whichUnit, action)
    local evtKey = heventKeyMap.beAttack
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--todo - 学习技能
--@getTriggerUnit 获取学习单位
--@getTriggerSkill 获取学习技能ID
hevent.onSkillStudy = function(whichUnit, action)
    local evtKey = heventKeyMap.skillStudy
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_HERO_SKILL)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetLearnedSkill(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--todo - 准备施放技能
--@getTriggerUnit 获取施放单位
--@getTargetUnit 获取目标单位(只对对目标施放有效)
--@getTriggerSkill 获取施放技能ID
--@getTargetLoc 获取施放目标点
hevent.onSkillReady = function(whichUnit, action)
    local evtKey = heventKeyMap.skillReady
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_CHANNEL)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                targetUnit = cj.GetSpellTargetUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
                targetLoc = cj.GetSpellTargetLoc(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--todo - 开始施放技能
--@getTriggerUnit 获取施放单位
--@getTargetUnit 获取目标单位(只对对目标施放有效)
--@getTriggerSkill 获取施放技能ID
--@getTargetLoc 获取施放目标点
hevent.onSkillStart = function(whichUnit, action)
    local evtKey = heventKeyMap.skillStart
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_CAST)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                targetUnit = cj.GetSpellTargetUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
                targetLoc = cj.GetSpellTargetLoc(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--todo - 停止施放技能
--@getTriggerUnit 获取施放单位
--@getTriggerSkill 获取施放技能ID
hevent.onSkillStop = function(whichUnit, action)
    local evtKey = heventKeyMap.skillStop
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_ENDCAST)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--todo - 发动技能效果
--@getTriggerUnit 获取施放单位
--@getTargetUnit 获取目标单位(只对对目标施放有效)
--@getTriggerSkill 获取施放技能ID
--@getTargetLoc 获取施放目标点
hevent.onSkillHappen = function(whichUnit, action)
    local evtKey = heventKeyMap.skillHappen
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_EFFECT)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                targetUnit = cj.GetSpellTargetUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
                targetLoc = cj.GetSpellTargetLoc(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 施放技能结束
-- @getTriggerUnit 获取施放单位
-- @getTriggerSkill 获取施放技能ID
hevent.onSkillOver = function(whichUnit, action)
    local evtKey = heventKeyMap.skillOver
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_FINISH)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 单位使用物品
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemUsed = function(whichUnit, action)
    local evtKey = heventKeyMap.itemUsed
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 出售物品(商店卖给玩家)
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemSell = function(whichUnit, action)
    local evtKey = heventKeyMap.itemSell
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 丢弃物品
-- @getTriggerUnit 获取触发/出售单位
-- @targetUnit 获取购买单位
-- @getTriggerItem 获取触发/出售物品
hevent.onItemDrop = function(whichUnit, action)
    local evtKey = heventKeyMap.itemDrop
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 获得物品
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemGet = function(whichUnit, action)
    local evtKey = heventKeyMap.itemGet
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 抵押物品（玩家把物品扔给商店）
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemPawn = function(whichUnit, action)
    local evtKey = heventKeyMap.itemPawn
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 物品被破坏
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemDestroy = function(whichItem, action)
    local evtKey = heventKeyMap.itemDestroy
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerItem = cj.GetManipulatedItem(),
                triggerUnit = cj.GetKillingUnit(),
            })
        end)
    end
    cj.TriggerRegisterDeathEvent(heventGlobalTgr[evtKey], whichItem)
    return hevent.onEventByHandle(evtKey, whichItem, action)
end
-- todo - 合成物品
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取合成的物品
hevent.onItemMix = function(whichUnit, action)
    local evtKey = heventKeyMap.itemMix
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 拆分物品
-- @getTriggerUnit 获取触发单位
-- @getId 获取拆分的物品ID
-- @getType 获取拆分的类型
--      - simple 单件拆分
--      - mixed 合成品拆分
hevent.onItemSeparate = function(whichUnit, action)
    local evtKey = heventKeyMap.itemSeparate
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 造成伤害
-- @getTriggerUnit 获取伤害来源
-- @getTargetUnit 获取被伤害单位
-- @getSourceUnit 获取伤害来源
-- @getDamage 获取初始伤害
-- @getRealDamage 获取实际伤害
-- @getDamageKind 获取伤害方式
-- @getDamageType 获取伤害类型
hevent.onDamage = function(whichUnit, action)
    local evtKey = heventKeyMap.damage
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 承受伤害
-- @getTriggerUnit 获取被伤害单位
-- @getSourceUnit 获取伤害来源
-- @getDamage 获取初始伤害
-- @getRealDamage 获取实际伤害
-- @getDamageKind 获取伤害方式
-- @getDamageType 获取伤害类型
hevent.onBeDamage = function(whichUnit, action)
    local evtKey = heventKeyMap.beDamage
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 回避攻击成功
-- @getTriggerUnit 获取触发单位
-- @getAttacker 获取攻击单位
hevent.onAvoid = function(whichUnit, action)
    local evtKey = heventKeyMap.avoid
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 攻击被回避
-- @getTriggerUnit 获取攻击单位
-- @getAttacker 获取攻击单位
-- @getTargetUnit 获取回避的单位
hevent.onBeAvoid = function(whichUnit, action)
    local evtKey = heventKeyMap.beAvoid
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 破防（护甲/魔抗）成功
-- @getBreakType 获取无视类型
-- @getTriggerUnit 获取触发无视单位
-- @getTargetUnit 获取目标单位
-- @getValue 获取破护甲的数值
-- @getValue2 获取破魔抗的百分比
hevent.onBreakArmor = function(whichUnit, action)
    local evtKey = heventKeyMap.breakArmor
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 被破防（护甲/魔抗）成功
-- @getBreakType 获取无视类型
-- @getTriggerUnit 获取被破甲单位
-- @getSourceUnit 获取来源单位
-- @getValue 获取破护甲的数值
-- @getValue2 获取破魔抗的百分比
hevent.onBeBreakArmor = function(whichUnit, action)
    local evtKey = heventKeyMap.beBreakArmor
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 眩晕成功
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取被眩晕单位
-- @getValue 获取眩晕几率百分比
-- @getDuring 获取眩晕时间（秒）
hevent.onSwim = function(whichUnit, action)
    local evtKey = heventKeyMap.swim
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 被眩晕
-- @getTriggerUnit 获取被眩晕单位
-- @getSourceUnit 获取来源单位
-- @getValue 获取眩晕几率百分比
-- @getDuring 获取眩晕时间（秒）
hevent.onBeSwim = function(whichUnit, action)
    local evtKey = heventKeyMap.beSwim
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 反伤时
-- @getTriggerUnit 获取触发单位
-- @getSourceUnit 获取来源单位
-- @getDamage 获取反伤伤害
hevent.onRebound = function(whichUnit, action)
    local evtKey = heventKeyMap.rebound
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 造成无法回避的伤害时
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取目标单位
-- @getDamage 获取伤害值
hevent.onNoAvoid = function(whichUnit, action)
    local evtKey = heventKeyMap.noAvoid
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 被造成无法回避的伤害时
-- @getTriggerUnit 获取触发单位
-- @getSourceUnit 获取来源单位
-- @getDamage 获取伤害值
hevent.onBeNoAvoid = function(whichUnit, action)
    local evtKey = heventKeyMap.beNoAvoid
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 物理暴击时
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取目标单位
-- @getDamage 获取暴击伤害值
-- @getValue 获取暴击几率百分比
-- @getValue2 获取暴击增幅百分比
hevent.onKnocking = function(whichUnit, action)
    local evtKey = heventKeyMap.knocking
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 承受物理暴击时
-- @getTriggerUnit 获取触发单位
-- @getSourceUnit 获取来源单位
-- @getDamage 获取暴击伤害值
-- @getValue 获取暴击几率百分比
-- @getValue2 获取暴击增幅百分比
hevent.onBeKnocking = function(whichUnit, action)
    local evtKey = heventKeyMap.beKnocking
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 魔法暴击时
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取目标单位
-- @getDamage 获取暴击伤害值
-- @getValue 获取暴击几率百分比
-- @getValue2 获取暴击增幅百分比
hevent.onViolence = function(whichUnit, action)
    local evtKey = heventKeyMap.violence
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 承受魔法暴击时
-- @getTriggerUnit 获取触发单位
-- @getSourceUnit 获取来源单位
-- @getDamage 获取暴击伤害值
-- @getValue 获取暴击几率百分比
-- @getValue2 获取暴击增幅百分比
hevent.onBeViolence = function(whichUnit, action)
    local evtKey = heventKeyMap.beViolence
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 分裂时
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取目标单位
-- @getDamage 获取分裂伤害值
-- @getRange 获取分裂范围(px)
-- @getValue 获取分裂百分比
hevent.onSpilt = function(whichUnit, action)
    local evtKey = heventKeyMap.spilt
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 承受分裂时
-- @getTriggerUnit 获取触发单位
-- @getSourceUnit 获取来源单位
-- @getDamage 获取分裂伤害值
-- @getRange 获取分裂范围(px)
-- @getValue 获取分裂百分比
hevent.onBeSpilt = function(whichUnit, action)
    local evtKey = heventKeyMap.beSpilt
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 吸血时
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取目标单位
-- @getDamage 获取吸血值
-- @getValue 获取吸血百分比
hevent.onHemophagia = function(whichUnit, action)
    local evtKey = heventKeyMap.hemophagia
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 被吸血时
-- @getTriggerUnit 获取触发单位
-- @getSourceUnit 获取来源单位
-- @getDamage 获取吸血值
-- @getValue 获取吸血百分比
hevent.onBeHemophagia = function(whichUnit, action)
    local evtKey = heventKeyMap.beHemophagia
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 技能吸血时
--@getTriggerUnit 获取触发单位
--@getTargetUnit 获取目标单位
--@getDamage 获取吸血值
--@getValue 获取吸血百分比
hevent.onSkillHemophagia = function(whichUnit, action)
    local evtKey = heventKeyMap.skillHemophagia
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 被技能吸血时
-- @getTriggerUnit 获取触发单位
-- @getSourceUnit 获取来源单位
-- @getDamage 获取吸血值
-- @getValue 获取吸血百分比
hevent.onBeSkillHemophagia = function(whichUnit, action)
    local evtKey = heventKeyMap.beSkillHemophagia
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 硬直时
-- @getTriggerUnit 获取触发单位
-- @getSourceUnit 获取来源单位
-- @getValue 获取硬直程度百分比
-- @getDuring 获取持续时间
hevent.onPunish = function(whichUnit, action)
    local evtKey = heventKeyMap.punish
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 死亡时
-- @getTriggerUnit 获取触发单位
-- @getKiller 获取凶手单位
hevent.onDead = function(whichUnit, action)
    local evtKey = heventKeyMap.dead
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 击杀时
-- @getTriggerUnit 获取触发单位
-- @getKiller 获取凶手单位
-- @getTargetUnit 获取死亡单位
hevent.onKill = function(whichUnit, action)
    local evtKey = heventKeyMap.kill
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 复活时(必须使用 hunit.reborn 方法才能嵌入到事件系统)
-- @getTriggerUnit 获取触发单位
hevent.onReborn = function(whichUnit, action)
    local evtKey = heventKeyMap.reborn
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 提升升等级时
-- @getTriggerUnit 获取触发单位
hevent.onLevelUp = function(whichUnit, action)
    local evtKey = heventKeyMap.levelUp
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 被召唤时
-- @getTriggerUnit 获取被召唤单位
hevent.onSummon = function(whichUnit, action)
    local evtKey = heventKeyMap.summon
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        hevent.TriggerRegisterAnyUnitEvent(heventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SUMMON)
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 进入某单位（whichUnit）范围内
-- @getTriggerUnit 获取被进入范围的中心单位
-- @getTriggerEnterUnit 获取进入范围的单位
-- @getRange 获取设定范围
hevent.onEnterUnitRange = function(whichUnit, range, action)
    local evtKey = heventKeyMap.enterUnitRange
    if (heventData[whichUnit].evtInit == nil) then
        heventData[whichUnit].evtInit = {}
    end
    if (heventData[whichUnit].evtInit[evtKey] == nil) then
        heventData[whichUnit].evtInit[evtKey] = true
        local tg = cj.CreateTrigger()
        cj.TriggerRegisterUnitInRangeSimple(tg, range, whichUnit)
        heventTgr[tg].triggerUnit = whichUnit
        heventTgr[tg].range = range
        cj.TriggerAddAction(tg, function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = hevent.getTriggerUnit(),
                triggerEnterUnit = cj.GetTriggerUnit(),
                range = hevent.getRange(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 离开某区域内
-- @getTriggerRect 获取被离开的矩形区域
-- @getTriggerUnit 获取离开矩形区域的单位
hevent.onEnterUnitRange = function(whichRect, action)
    local evtKey = heventKeyMap.leaveRect
    if (heventData[whichRect].evtInit == nil) then
        heventData[whichRect].evtInit = {}
    end
    if (heventData[whichRect].evtInit[evtKey] == nil) then
        heventData[whichRect].evtInit[evtKey] = true
        local tg = cj.CreateTrigger()
        cj.TriggerRegisterLeaveRectSimple(tg, whichRect)
        heventTgr[tg].triggerRect = whichRect
        cj.TriggerAddAction(tg, function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerRect = hevent.getTriggerRect(),
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichRect, action)
end
-- todo - 当聊天时
-- @params matchAll 是否全匹配，false为like
-- @getTriggerPlayer 获取聊天的玩家
-- @getTriggerString 获取聊天的内容
-- @getTriggerStringMatched 获取匹配命中的内容
hevent.onChat = function(whichPlayer, chatStr, matchAll, action)
    local evtKey = heventKeyMap.chat
    local tg = cj.CreateTrigger()
    cj.TriggerAddAction(tg, function()
        hevent.triggerEvent({
            triggerKey = evtKey,
            triggerPlayer = cj.GetTriggerPlayer(),
            triggerString = cj.GetEventPlayerChatString(),
            triggerStringMatched = cj.GetEventPlayerChatStringMatched(),
        })
    end)
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            cj.TriggerRegisterPlayerChatEvent(trig, p, chatStr, matchAll)
            hevent.onEventByHandle(evtKey, p, action)
        end
        return
    else
        cj.TriggerRegisterPlayerChatEvent(tg, whichPlayer, chatStr, matchAll)
        return hevent.onEventByHandle(evtKey, whichPlayer, action)
    end
end
-- todo - 按ESC
-- @getTriggerPlayer 获取触发玩家
hevent.onEsc = function(whichPlayer, action)
    local evtKey = heventKeyMap.esc
    if (heventData[whichPlayer].evtInit == nil) then
        heventData[whichPlayer].evtInit = {}
    end
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            if (heventData[p].evtInit[evtKey] == nil) then
                heventData[p].evtInit[evtKey] = true
                local tg = cj.CreateTrigger()
                cj.TriggerRegisterPlayerEventEndCinematic(tg, p)
                cj.TriggerAddAction(tg, function()
                    hevent.triggerEvent({
                        triggerKey = evtKey,
                        triggerPlayer = cj.GetTriggerPlayer(),
                    })
                end)
                hevent.onEventByHandle(evtKey, p, action)
            end
        end
        return
    else
        if (heventData[whichPlayer].evtInit[evtKey] == nil) then
            heventData[whichPlayer].evtInit[evtKey] = true
            local tg = cj.CreateTrigger()
            cj.TriggerRegisterPlayerEventEndCinematic(tg, whichPlayer)
            cj.TriggerAddAction(tg, function()
                hevent.triggerEvent({
                    triggerKey = evtKey,
                    triggerPlayer = cj.GetTriggerPlayer(),
                })
            end)
            return hevent.onEventByHandle(evtKey, whichPlayer, action)
        end
    end
end
-- todo - 选择单位(基准)
-- 单选evtKey=selection1，双击=selection2，如此类推
hevent.onSelectionBind = function(whichPlayer, action, evtKey)
    if (heventData[whichPlayer].evtInit == nil) then
        heventData[whichPlayer].evtInit = {}
    end
    if (whichPlayer == nil) then
        return
    end
    if (heventData[whichPlayer].evtInit.selectionBind == nil) then
        heventData[whichPlayer].evtInit.selectionBind = true
        if (heventData[whichPlayer].clickQty == nil) then
            heventData[whichPlayer].clickQty = 0
        end
        local tg = cj.CreateTrigger()
        hevent.TriggerRegisterPlayerSelectionEvent(tg, whichPlayer, true)
        cj.TriggerAddAction(tg, function()
            local triggerPlayer = cj.GetTriggerPlayer()
            local triggerUnit = cj.GetTriggerUnit()
            local qty = 1 + heventData[whichPlayer].clickQty
            if (qty < 1) then
                qty = 1
            end
            qty = math.ceil(qty)
            heventData[whichPlayer].clickQty = qty
            hevent.triggerEvent({
                triggerKey = heventKeyMap.selection .. qty,
                triggerPlayer = triggerPlayer,
                triggerUnit = triggerUnit,
            })
            htime.setTimeout(0.3, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                heventData[whichPlayer].clickQty = heventData[whichPlayer].clickQty - 1
            end)
        end)
    end
    return hevent.onEventByHandle(evtKey, whichPlayer, action)
end
-- todo - 玩家 N 击选择单位
-- qty 需要点击次数
-- getTriggerPlayer 获取触发玩家
-- getTriggerUnit 获取触发单位
hevent.onSelection = function(whichPlayer, qty, action)
    hevent.onSelectionBind(whichPlayer, action, heventKeyMap.selection .. qty)
end
-- todo - 玩家取消选择单位
-- getTriggerPlayer 获取触发玩家
-- getTriggerUnit 获取触发单位
hevent.onUnSelection = function(whichPlayer, action)
    local evtKey = heventKeyMap.unSelection
    local tg = cj.CreateTrigger()
    cj.TriggerAddAction(tg, function()
        hevent.triggerEvent({
            triggerKey = evtKey,
            triggerPlayer = cj.GetTriggerPlayer(),
            triggerUnit = cj.GetTriggerUnit(),
        })
    end)
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            hevent.TriggerRegisterPlayerSelectionEvent(tg, whichPlayer, false)
            hevent.onEventByHandle(evtKey, p, action)
        end
        return
    else
        hevent.TriggerRegisterPlayerSelectionEvent(tg, whichPlayer, false)
        return hevent.onEventByHandle(evtKey, p, action)
    end
end
-- todo - 建筑升级开始时
-- @getTriggerUnit 获取触发单位
hevent.onUpgradeStart = function(whichUnit, action)
    local evtKey = heventKeyMap.upgradeStart
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(heventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_UPGRADE_START)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 建筑升级取消时
-- @getTriggerUnit 获取触发单位
hevent.onUpgradeCancel = function(whichUnit, action)
    local evtKey = heventKeyMap.upgradeCancel
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(heventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_UPGRADE_CANCEL)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 建筑升级完成时
-- @getTriggerUnit 获取触发单位
hevent.onUpgradeFinish = function(whichUnit, action)
    local evtKey = heventKeyMap.upgradeFinish
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(heventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_UPGRADE_FINISH)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 任意建筑建造开始时
-- @getTriggerUnit 获取触发单位
hevent.onConstructStart = function(whichPlayer, action)
    local evtKey = heventKeyMap.constructStart
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            cj.TriggerRegisterPlayerUnitEvent(heventGlobalTgr[evtKey], p, EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)
            hevent.onEventByHandleDefaultTrigger(evtKey, p, action, heventGlobalTgr[evtKey])
        end
        return
    else
        cj.TriggerRegisterPlayerUnitEvent(heventGlobalTgr[evtKey], whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)
        return hevent.onEventByHandleDefaultTrigger(evtKey, whichPlayer, action, heventGlobalTgr[evtKey])
    end
end
-- todo - 任意建筑建造取消时
-- @getTriggerUnit 获取触发单位
hevent.onConstructCancel = function(whichPlayer, action)
    local evtKey = heventKeyMap.constructCancel
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetCancelledStructure(),
            })
        end)
    end
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            cj.TriggerRegisterPlayerUnitEvent(heventGlobalTgr[evtKey], p, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
            hevent.onEventByHandleDefaultTrigger(evtKey, p, action, heventGlobalTgr[evtKey])
        end
        return
    else
        cj.TriggerRegisterPlayerUnitEvent(heventGlobalTgr[evtKey], whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
        return hevent.onEventByHandleDefaultTrigger(evtKey, whichPlayer, action, heventGlobalTgr[evtKey])
    end
end
-- todo - 任意建筑建造完成时
-- @getTriggerUnit 获取触发单位
hevent.onConstructFinish = function(whichPlayer, action)
    local evtKey = heventKeyMap.constructFinish
    if (heventGlobalTgr[evtKey] == nil) then
        heventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(heventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetConstructedStructure(),
            })
        end)
    end
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            cj.TriggerRegisterPlayerUnitEvent(heventGlobalTgr[evtKey], p, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
            hevent.onEventByHandleDefaultTrigger(evtKey, p, action, heventGlobalTgr[evtKey])
        end
        return
    else
        cj.TriggerRegisterPlayerUnitEvent(heventGlobalTgr[evtKey], whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
        return hevent.onEventByHandleDefaultTrigger(evtKey, whichPlayer, action, heventGlobalTgr[evtKey])
    end
end
-- todo - 任意单位注册进hJLua系统时(注意这是全局事件)
-- @getTriggerUnit 获取触发单位
hevent.onRegister = function(action)
    local evtKey = heventKeyMap.register
    return hevent.onEventByHandle(evtKey, hevent.defaultHandle, action)
end
-- todo - 任意单位经过hero方法被玩家所挑选为英雄时(注意这是全局事件)
-- @getTriggerUnit 获取触发单位
hevent.onPickHero = function(action)
    local evtKey = heventKeyMap.pickHero
    return hevent.onEventByHandle(evtKey, hevent.defaultHandle, action)
end

