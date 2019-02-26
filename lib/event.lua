heventGlobalTgr = {}
heventTgr = {}
heventData = {}
hevent = {
    -- set最后一位伤害的单位
    setLastDamageUnit = function(which, last)
        heventData[which].lastDamageUnit = last
    end,
    -- get最后一位伤害的单位
    getLastDamageUnit = function(which)
        return heventData[which].lastDamageUnit or nil
    end,
}
-- 模拟BJ函数TriggerRegisterAnyUnitEventBJ
hevent.TriggerRegisterAnyUnitEvent = function(trig, whichEvent)
    for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
        cj.TriggerRegisterPlayerUnitEvent(trig, cj.Player(i-1), whichEvent, nil)
    end
end
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
hevent.onEventByHandle = function(evtKey, whichHandle, action)
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
    local tg = cj.CreateTrigger()
    cj.TriggerAddAction(tg, action)
    table.insert(heventData[whichHandle].trigger[evtKey], tg)
    return tg
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

-- todo - 注意到攻击目标
-- @getTriggerUnit 获取触发单位
-- @getTargetUnit 获取被注意/目标单位
hevent.onAttackDetect = function(whichUnit, action)
    local evtKey = 'attackDetect'
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
    local evtKey = 'attackGetTarget'
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
    local evtKey = 'attackReady'
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
    local evtKey = 'beAttackReady'
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
    local evtKey = 'attack'
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
    local evtKey = 'beAttack'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--todo - 学习技能
--@getTriggerUnit 获取学习单位
--@getTriggerSkill 获取学习技能ID
hevent.onSkillStudy = function(whichUnit, action)
    local evtKey = 'skillStudy'
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
    local evtKey = 'skillReady'
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
    local evtKey = 'skillStart'
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
    local evtKey = 'skillStop'
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
    local evtKey = 'skillHappen'
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
    local evtKey = 'skillOver'
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
    local evtKey = 'itemUsed'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 出售物品(商店卖给玩家)
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemSell = function(whichUnit, action)
    local evtKey = 'itemSell'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 丢弃物品
-- @getTriggerUnit 获取触发/出售单位
-- @targetUnit 获取购买单位
-- @getTriggerItem 获取触发/出售物品
hevent.onItemDrop = function(whichUnit, action)
    local evtKey = 'itemDrop'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 获得物品
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemGet = function(whichUnit, action)
    local evtKey = 'itemGet'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 抵押物品（玩家把物品扔给商店）
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemPawn = function(whichUnit, action)
    local evtKey = 'itemPawn'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 物品被破坏
-- @getTriggerUnit 获取触发单位
-- @getTriggerItem 获取触发物品
hevent.onItemDestroy = function(whichItem, action)
    local evtKey = 'itemDestroy'
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
    local evtKey = 'itemMix'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 拆分物品
-- @getTriggerUnit 获取触发单位
-- @getId 获取拆分的物品ID
-- @getType 获取拆分的类型
--      - simple 单件拆分
--      - mixed 合成品拆分
hevent.onItemSeparate = function(whichUnit, action)
    local evtKey = 'itemSeparate'
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
    local evtKey = 'damage'
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
    local evtKey = 'beDamage'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 回避攻击成功
-- @getTriggerUnit 获取触发单位
-- @getAttacker 获取攻击单位
hevent.onAvoid = function(whichUnit, action)
    local evtKey = 'avoid'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 攻击被回避
-- @getTriggerUnit 获取攻击单位
-- @getAttacker 获取攻击单位
-- @getTargetUnit 获取回避的单位
hevent.onBeAvoid = function(whichUnit, action)
    local evtKey = 'beAvoid'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 无视护甲成功
-- @getBreakType 获取无视类型
-- @getTriggerUnit 获取破甲单位
-- @getTargetUnit 获取目标单位
-- @getValue 获取破甲的数值
hevent.onBreakDefend = function(whichUnit, action)
    local evtKey = 'breakDefend'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- todo - 被无视护甲
-- @getBreakType 获取无视类型
-- @getTriggerUnit 获取被破甲单位
-- @getSourceUnit 获取来源单位
-- @getValue 获取破甲的数值
hevent.onBeBreakDefend = function(whichUnit, action)
    local evtKey = 'beBreakDefend'
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end