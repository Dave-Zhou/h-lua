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
    broken = "broken",
    beBroken = "beBroken",
    silent = "silent",
    beSilent = "beSilent",
    unarm = "unarm",
    beUnarm = "beUnarm",
    fetter = "fetter",
    beFetter = "beFetter",
    bomb = "bomb",
    beBomb = "beBomb",
    lightningChain = "lightningChain",
    beLightningChain = "beLightningChain",
    crackFly = "crackFly",
    beCrackFly = "beCrackFly",
    rebound = "rebound",
    noAvoid = "noAvoid",
    beNoAvoid = "beNoAvoid",
    knocking = "knocking",
    beKnocking = "beKnocking",
    violence = "violence",
    beViolence = "beViolence",
    spilt = "spilt",
    beSpilt = "beSpilt",
    limitToughness = "limitToughness",
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
local hevent = {
    defaultHandle = cj.Player(PLAYER_NEUTRAL_PASSIVE),
    -- set最后一位伤害的单位
    setLastDamageUnit = function(which, last)
        hRuntime.event[which].lastDamageUnit = last
    end,
    -- get最后一位伤害的单位
    getLastDamageUnit = function(which)
        return hRuntime.event[which].lastDamageUnit or nil
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
        if (hRuntime.event[bean.triggerHandle] == nil) then
            return
        end
        if (hRuntime.event[bean.triggerHandle].trigger == nil) then
            return
        end
        if (hRuntime.event[bean.triggerHandle].trigger[bean.triggerKey] == nil) then
            return
        end
        local triggers = hRuntime.event[bean.triggerHandle].trigger[bean.triggerKey]
        if (triggers == nil or #triggers == 0) then
            return
        end
        for _, tempTgr in pairs(triggers) do
            if (bean.triggerUnit ~= nil) then
                hRuntime.eventTgr[tempTgr].triggerUnit = bean.triggerUnit
            end
            if (bean.triggerEnterUnit ~= nil) then
                hRuntime.eventTgr[tempTgr].triggerEnterUnit = bean.triggerEnterUnit
            end
            if (bean.triggerRect ~= nil) then
                hRuntime.eventTgr[tempTgr].triggerRect = bean.triggerRect
            end
            if (bean.triggerItem ~= nil) then
                hRuntime.eventTgr[tempTgr].triggerItem = bean.triggerItem
            end
            if (bean.triggerPlayer ~= nil) then
                hRuntime.eventTgr[tempTgr].triggerPlayer = bean.triggerPlayer
            end
            if (bean.triggerString ~= nil) then
                hRuntime.eventTgr[tempTgr].triggerString = bean.triggerString
            end
            if (bean.triggerStringMatched ~= nil) then
                hRuntime.eventTgr[tempTgr].triggerStringMatched = bean.triggerStringMatched
            end
            if (bean.triggerSkill ~= nil) then
                hRuntime.eventTgr[tempTgr].triggerSkill = bean.triggerSkill
            end
            if (bean.sourceUnit ~= nil) then
                hRuntime.eventTgr[tempTgr].sourceUnit = bean.sourceUnit
            end
            if (bean.targetUnit ~= nil) then
                hRuntime.eventTgr[tempTgr].targetUnit = bean.targetUnit
            end
            if (bean.targetLoc ~= nil) then
                hRuntime.eventTgr[tempTgr].targetLoc = bean.targetLoc
            end
            if (bean.attacker ~= nil) then
                hRuntime.eventTgr[tempTgr].attacker = bean.attacker
            end
            if (bean.killer ~= nil) then
                hRuntime.eventTgr[tempTgr].killer = bean.killer
            end
            if (bean.damage ~= nil) then
                hRuntime.eventTgr[tempTgr].damage = bean.damage
            end
            if (bean.realDamage ~= nil) then
                hRuntime.eventTgr[tempTgr].realDamage = bean.realDamage
            end
            if (bean.id ~= nil) then
                hRuntime.eventTgr[tempTgr].id = bean.id
            end
            if (bean.range ~= nil) then
                hRuntime.eventTgr[tempTgr].range = bean.range
            end
            if (bean.qty ~= nil) then
                hRuntime.eventTgr[tempTgr].qty = bean.qty
            end
            if (bean.index ~= nil) then
                hRuntime.eventTgr[tempTgr].index = bean.index
            end
            if (bean.high ~= nil) then
                hRuntime.eventTgr[tempTgr].high = bean.high
            end
            if (bean.distance ~= nil) then
                hRuntime.eventTgr[tempTgr].distance = bean.distance
            end
            if (bean.value ~= nil) then
                hRuntime.eventTgr[tempTgr].value = bean.value
            end
            if (bean.percent ~= nil) then
                hRuntime.eventTgr[tempTgr].percent = bean.percent
            end
            if (bean.during ~= nil) then
                hRuntime.eventTgr[tempTgr].during = bean.during
            end
            if (bean.damageKind ~= nil) then
                hRuntime.eventTgr[tempTgr].damageKind = bean.damageKind
            end
            if (bean.damageType ~= nil) then
                hRuntime.eventTgr[tempTgr].damageType = bean.damageType
            end
            if (bean.breakType ~= nil) then
                hRuntime.eventTgr[tempTgr].breakType = bean.breakType
            end
            if (bean.type ~= nil) then
                hRuntime.eventTgr[tempTgr].type = bean.type
            end
            if (bean.isNoAvoid ~= false) then
                hRuntime.eventTgr[tempTgr].isNoAvoid = bean.isNoAvoid
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
    if (hRuntime.event[whichHandle] == nil) then
        hRuntime.event[whichHandle] = {}
    end
    if (hRuntime.event[whichHandle].trigger == nil) then
        hRuntime.event[whichHandle].trigger = {}
    end
    if (hRuntime.event[whichHandle].trigger[evtKey] == nil) then
        hRuntime.event[whichHandle].trigger[evtKey] = {}
    end
    table.insert(hRuntime.event[whichHandle].trigger[evtKey], defaultTrigger)
    return defaultTrigger
end
hevent.onEventByHandle = function(evtKey, whichHandle, action)
    local tg = cj.CreateTrigger()
    cj.TriggerAddAction(tg, action)
    return hevent.onEventByHandleDefaultTrigger(evtKey, whichHandle, action, tg)
end

-- 获取 triggerUnit 单位
hevent.getTriggerUnit = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].triggerUnit or nil
end
-- 获取 triggerEnterUnit 单位
hevent.getTriggerEnterUnit = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].triggerEnterUnit or nil
end
-- 获取 triggerRect 区域
hevent.getTriggerRect = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].triggerRect or nil
end
-- 获取 triggerItem 物品
hevent.getTriggerItem = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].triggerItem or nil
end
-- 获取 triggerPlayer 玩家
hevent.getTriggerPlayer = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].triggerPlayer or nil
end
-- 获取 triggerString 字符串
hevent.getTriggerString = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].triggerString or nil
end
-- 获取 triggerStringMatched 字符串
hevent.getTriggerStringMatched = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].triggerStringMatched or nil
end
-- 获取 triggerSkill 整型
hevent.getTriggerSkill = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].triggerSkill or nil
end
-- 获取 sourceUnit 单位
hevent.getSourceUnit = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].sourceUnit or nil
end
-- 获取 targetUnit 单位
hevent.getTargetUnit = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].targetUnit or nil
end
-- 获取 targetLoc 点
hevent.getTargetLoc = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].targetLoc or nil
end
-- 获取 attacker 单位
hevent.getAttacker = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].attacker or nil
end
-- 获取 killer 单位
hevent.getKiller = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].killer or nil
end
-- 获取 damage 实数
hevent.getDamage = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].damage or nil
end
-- 获取 realDamage 实数
hevent.getRealDamage = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].realDamage or nil
end
-- 获取 id 整型
hevent.getId = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].id or nil
end
-- 获取 range 实数
hevent.getRange = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].range or nil
end
-- 获取 qty 实数
hevent.getQty = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].qty or nil
end
-- 获取 index 实数
hevent.getIndex = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].index or nil
end
-- 获取 high 实数
hevent.getHigh = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].high or nil
end
-- 获取 distance 实数
hevent.getDistance = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].distance or nil
end
-- 获取 value 实数
hevent.getValue = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].value or nil
end
-- 获取 percent 百分比（%）
hevent.getPercent = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].percent or nil
end
-- 获取 during 实数
hevent.getDuring = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].during or nil
end
-- 获取 damageKind 字符串
hevent.getDamageKind = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].damageKind or nil
end
-- 获取 damageType 字符串
hevent.getDamageType = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].damageType or nil
end
-- 获取 breakType 字符串
hevent.getBreakType = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].breakType or nil
end
-- 获取 type 字符串
hevent.getType = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].type or nil
end
-- 获取 isNoAvoid 布尔值
hevent.getIsNoAvoid = function()
    return hRuntime.eventTgr[cj.GetTriggeringTrigger()].isNoAvoid or nil
end

-- 注意到攻击目标
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被注意/目标单位
hevent.onAttackDetect = function(whichUnit, action)
    local evtKey = heventKeyMap.attackDetect
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                targetUnit = cj.GetEventTargetUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(hRuntime.eventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_ACQUIRED_TARGET)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- 获取攻击目标
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被获取/目标单位
hevent.onAttackGetTarget = function(whichUnit, action)
    local evtKey = heventKeyMap.attackGetTarget
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                targetUnit = cj.GetEventTargetUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(hRuntime.eventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_TARGET_IN_RANGE)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- 准备攻击
--- getTriggerUnit 获取攻击单位
--- getTargetUnit 获取被攻击单位
--- getAttacker 获取攻击单位
hevent.onAttackReadyAction = function(whichUnit, action)
    local evtKey = heventKeyMap.attackReady
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_ATTACKED)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
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
--准备被攻击
--- getTriggerUnit 获取被攻击单位
--- getTargetUnit 获取攻击单位
--- getAttacker 获取攻击单位
hevent.onBeAttackReady = function(whichUnit, action)
    local evtKey = heventKeyMap.beAttackReady
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_ATTACKED)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
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
--造成攻击
--- getTriggerUnit 获取攻击来源
--- getTargetUnit 获取被攻击单位
--- getAttacker 获取攻击来源
--- getDamage 获取初始伤害
--- getRealDamage 获取实际伤害
--- getDamageKind 获取伤害方式
--- getDamageType 获取伤害类型
hevent.onAttack = function(whichUnit, action)
    local evtKey = heventKeyMap.attack
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--承受攻击
--- getTriggerUnit 获取被攻击单位
--- getAttacker 获取攻击来源
--- getDamage 获取初始伤害
--- getRealDamage 获取实际伤害
--- getDamageKind 获取伤害方式
--- getDamageType 获取伤害类型
hevent.onBeAttack = function(whichUnit, action)
    local evtKey = heventKeyMap.beAttack
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- 学习技能
--- getTriggerUnit 获取学习单位
--- getTriggerSkill 获取学习技能ID
hevent.onSkillStudy = function(whichUnit, action)
    local evtKey = heventKeyMap.skillStudy
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_HERO_SKILL)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetLearnedSkill(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- 准备施放技能
--- getTriggerUnit 获取施放单位
--- getTargetUnit 获取目标单位(只对对目标施放有效)
--- getTriggerSkill 获取施放技能ID
--- getTargetLoc 获取施放目标点
hevent.onSkillReady = function(whichUnit, action)
    local evtKey = heventKeyMap.skillReady
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_CHANNEL)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
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
-- 开始施放技能
--- getTriggerUnit 获取施放单位
--- getTargetUnit 获取目标单位(只对对目标施放有效)
--- getTriggerSkill 获取施放技能ID
--- getTargetLoc 获取施放目标点
hevent.onSkillStart = function(whichUnit, action)
    local evtKey = heventKeyMap.skillStart
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_CAST)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
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
-- 停止施放技能
--- getTriggerUnit 获取施放单位
--- getTriggerSkill 获取施放技能ID
hevent.onSkillStop = function(whichUnit, action)
    local evtKey = heventKeyMap.skillStop
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_ENDCAST)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
-- 发动技能效果
--- getTriggerUnit 获取施放单位
--- getTargetUnit 获取目标单位(只对对目标施放有效)
--- getTriggerSkill 获取施放技能ID
--- getTargetLoc 获取施放目标点
hevent.onSkillHappen = function(whichUnit, action)
    local evtKey = heventKeyMap.skillHappen
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_EFFECT)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
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
--施放技能结束
--- getTriggerUnit 获取施放单位
--- getTriggerSkill 获取施放技能ID
hevent.onSkillOver = function(whichUnit, action)
    local evtKey = heventKeyMap.skillOver
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SPELL_FINISH)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
                triggerSkill = cj.GetSpellAbilityId(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--单位使用物品
--- getTriggerUnit 获取触发单位
--- getTriggerItem 获取触发物品
hevent.onItemUsed = function(whichUnit, action)
    local evtKey = heventKeyMap.itemUsed
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--出售物品(商店卖给玩家)
--- getTriggerUnit 获取触发单位
--- getTriggerItem 获取触发物品
hevent.onItemSell = function(whichUnit, action)
    local evtKey = heventKeyMap.itemSell
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--丢弃物品
--- getTriggerUnit 获取触发/出售单位
--- getTargetUnit 获取购买单位
--- getTriggerItem 获取触发/出售物品
hevent.onItemDrop = function(whichUnit, action)
    local evtKey = heventKeyMap.itemDrop
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--获得物品
--- getTriggerUnit 获取触发单位
--- getTriggerItem 获取触发物品
hevent.onItemGet = function(whichUnit, action)
    local evtKey = heventKeyMap.itemGet
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--抵押物品（玩家把物品扔给商店）
--- getTriggerUnit 获取触发单位
--- getTriggerItem 获取触发物品
hevent.onItemPawn = function(whichUnit, action)
    local evtKey = heventKeyMap.itemPawn
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--物品被破坏
--- getTriggerUnit 获取触发单位
--- getTriggerItem 获取触发物品
hevent.onItemDestroy = function(whichItem, action)
    local evtKey = heventKeyMap.itemDestroy
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerItem = cj.GetManipulatedItem(),
                triggerUnit = cj.GetKillingUnit(),
            })
        end)
    end
    cj.TriggerRegisterDeathEvent(hRuntime.eventGlobalTgr[evtKey], whichItem)
    return hevent.onEventByHandle(evtKey, whichItem, action)
end
--合成物品
--- getTriggerUnit 获取触发单位
--- getTriggerItem 获取合成的物品
hevent.onItemMix = function(whichUnit, action)
    local evtKey = heventKeyMap.itemMix
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--拆分物品
--- getTriggerUnit 获取触发单位
--- getId 获取拆分的物品ID
--- getType 获取拆分的类型 { simple 单件拆分 | mixed 合成品拆分 }
hevent.onItemSeparate = function(whichUnit, action)
    local evtKey = heventKeyMap.itemSeparate
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--造成伤害
--- getTriggerUnit 获取伤害来源
--- getTargetUnit 获取被伤害单位
--- getSourceUnit 获取伤害来源
--- getDamage 获取初始伤害
--- getRealDamage 获取实际伤害
--- getDamageKind 获取伤害方式
--- getDamageType 获取伤害类型
hevent.onDamage = function(whichUnit, action)
    local evtKey = heventKeyMap.damage
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--承受伤害
--- getTriggerUnit 获取被伤害单位
--- getSourceUnit 获取伤害来源
--- getDamage 获取初始伤害
--- getRealDamage 获取实际伤害
--- getDamageKind 获取伤害方式
--- getDamageType 获取伤害类型
hevent.onBeDamage = function(whichUnit, action)
    local evtKey = heventKeyMap.beDamage
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--回避攻击成功
--- getTriggerUnit 获取触发单位
--- getAttacker 获取攻击单位
hevent.onAvoid = function(whichUnit, action)
    local evtKey = heventKeyMap.avoid
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--攻击被回避
--- getTriggerUnit 获取攻击单位
--- getAttacker 获取攻击单位
--- getTargetUnit 获取回避的单位
hevent.onBeAvoid = function(whichUnit, action)
    local evtKey = heventKeyMap.beAvoid
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--破防（护甲/魔抗）成功
--- getBreakType 获取无视类型
--- getTriggerUnit 获取触发无视单位
--- getTargetUnit 获取目标单位
--- getValue 获取破护甲的数值
hevent.onBreakArmor = function(whichUnit, action)
    local evtKey = heventKeyMap.breakArmor
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被破防（护甲/魔抗）成功
--- getBreakType 获取无视类型
--- getTriggerUnit 获取被破甲单位
--- getSourceUnit 获取来源单位
--- getValue 获取破护甲的数值
hevent.onBeBreakArmor = function(whichUnit, action)
    local evtKey = heventKeyMap.beBreakArmor
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--眩晕成功
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被眩晕单位
--- getPercent 获取眩晕几率百分比
--- getDuring 获取眩晕时间（秒）
--- getDamage 获取眩晕实际伤害
hevent.onSwim = function(whichUnit, action)
    local evtKey = heventKeyMap.swim
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被眩晕
--- getTriggerUnit 获取被眩晕单位
--- getSourceUnit 获取来源单位
--- getPercent 获取眩晕几率百分比
--- getDuring 获取眩晕时间（秒）
--- getDamage 获取眩晕实际伤害
hevent.onBeSwim = function(whichUnit, action)
    local evtKey = heventKeyMap.beSwim
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--打断成功
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被打断单位
--- getPercent 获取打断几率百分比
--- getDamage 获取打断伤害
hevent.onBroken = function(whichUnit, action)
    local evtKey = heventKeyMap.broken
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被打断
--- getTriggerUnit 获取被眩晕单位
--- getSourceUnit 获取来源单位
--- getPercent 获取打断几率百分比
--- getDamage 获取打断伤害
hevent.onBeSwim = function(whichUnit, action)
    local evtKey = heventKeyMap.beBroken
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--沉默成功
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被沉默单位
--- getPercent 获取沉默几率百分比
--- getDuring 获取沉默时间（秒）
--- getDamage 获取沉默伤害
hevent.onSilent = function(whichUnit, action)
    local evtKey = heventKeyMap.silent
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被沉默
--- getTriggerUnit 获取被沉默单位
--- getSourceUnit 获取来源单位
--- getPercent 获取沉默几率百分比
--- getDuring 获取沉默时间（秒）
--- getDamage 获取沉默伤害
hevent.onBeSilent = function(whichUnit, action)
    local evtKey = heventKeyMap.beSilent
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--缴械成功
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被缴械单位
--- getPercent 获取缴械几率百分比
--- getDuring 获取缴械时间（秒）
--- getDamage 获取缴械伤害
hevent.onUnarm = function(whichUnit, action)
    local evtKey = heventKeyMap.unarm
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被缴械
--- getTriggerUnit 获取被缴械单位
--- getSourceUnit 获取来源单位
--- getPercent 获取缴械几率百分比
--- getDuring 获取缴械时间（秒）
--- getDamage 获取缴械伤害
hevent.onBeUnarm = function(whichUnit, action)
    local evtKey = heventKeyMap.beUnarm
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--缚足成功
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被缚足单位
--- getPercent 获取缚足几率百分比
--- getDuring 获取缚足时间（秒）
--- getDamage 获取缚足伤害
hevent.onFetter = function(whichUnit, action)
    local evtKey = heventKeyMap.fetter
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被缚足
--- getTriggerUnit 获取被缚足单位
--- getSourceUnit 获取来源单位
--- getPercent 获取缚足几率百分比
--- getDuring 获取缚足时间（秒）
--- getDamage 获取缚足伤害
hevent.onBeFetter = function(whichUnit, action)
    local evtKey = heventKeyMap.beFetter
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--爆破成功
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被爆破单位
--- getPercent 获取爆破几率百分比
--- getDamage 获取爆破伤害
--- getRange 获取爆破范围
hevent.onBomb = function(whichUnit, action)
    local evtKey = heventKeyMap.bomb
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被爆破
--- getTriggerUnit 获取被爆破单位
--- getSourceUnit 获取来源单位
--- getPercent 获取爆破几率百分比
--- getDamage 获取爆破伤害
--- getRange 获取爆破范围
hevent.onBeBomb = function(whichUnit, action)
    local evtKey = heventKeyMap.beBomb
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--闪电链成功
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被闪电链单位
--- getPercent 获取闪电链几率百分比
--- getDamage 获取闪电链伤害
--- getRange 获取闪电链范围
--- getQty 获取闪电链数量
hevent.onLightningChain = function(whichUnit, action)
    local evtKey = heventKeyMap.lightningChain
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被闪电链
--- getTriggerUnit 获取被闪电链单位
--- getSourceUnit 获取来源单位
--- getDamage 获取闪电链伤害
--- getRange 获取闪电链范围
--- getIndex 获取单位是第几个被电到的
hevent.onBeLightningChain = function(whichUnit, action)
    local evtKey = heventKeyMap.beLightningChain
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--击飞成功
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取被闪电链单位
--- getPercent 获取击飞几率百分比
--- getDamage 获取击飞伤害
--- getHigh 获取击飞高度
--- getDistance 获取击飞距离
hevent.onCrackFly = function(whichUnit, action)
    local evtKey = heventKeyMap.crackFly
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被击飞
--- getTriggerUnit 获取被击飞单位
--- getSourceUnit 获取来源单位
--- getDamage 获取击飞伤害
--- getHigh 获取击飞高度
--- getDistance 获取击飞距离
hevent.onBeCrackFly = function(whichUnit, action)
    local evtKey = heventKeyMap.beCrackFly
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end

--反伤时
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
--- getDamage 获取反伤伤害
hevent.onRebound = function(whichUnit, action)
    local evtKey = heventKeyMap.rebound
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--造成无法回避的伤害时
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取目标单位
--- getDamage 获取伤害值
hevent.onNoAvoid = function(whichUnit, action)
    local evtKey = heventKeyMap.noAvoid
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被造成无法回避的伤害时
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
--- getDamage 获取伤害值
hevent.onBeNoAvoid = function(whichUnit, action)
    local evtKey = heventKeyMap.beNoAvoid
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--物理暴击时
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取目标单位
--- getDamage 获取暴击伤害值
--- getValue 获取暴击几率百分比
--- getPercent 获取暴击增幅百分比
hevent.onKnocking = function(whichUnit, action)
    local evtKey = heventKeyMap.knocking
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--承受物理暴击时
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
--- getDamage 获取暴击伤害值
--- getValue 获取暴击几率百分比
--- getPercent 获取暴击增幅百分比
hevent.onBeKnocking = function(whichUnit, action)
    local evtKey = heventKeyMap.beKnocking
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--魔法暴击时
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取目标单位
--- getDamage 获取暴击伤害值
--- getValue 获取暴击几率百分比
--- getPercent 获取暴击增幅百分比
hevent.onViolence = function(whichUnit, action)
    local evtKey = heventKeyMap.violence
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--承受魔法暴击时
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
--- getDamage 获取暴击伤害值
--- getValue 获取暴击几率百分比
--- getPercent 获取暴击增幅百分比
hevent.onBeViolence = function(whichUnit, action)
    local evtKey = heventKeyMap.beViolence
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--分裂时
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取目标单位
--- getDamage 获取分裂伤害值
--- getRange 获取分裂范围(px)
--- getPercent 获取分裂百分比
hevent.onSpilt = function(whichUnit, action)
    local evtKey = heventKeyMap.spilt
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--承受分裂时
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
--- getDamage 获取分裂伤害值
--- getRange 获取分裂范围(px)
--- getPercent 获取分裂百分比
hevent.onBeSpilt = function(whichUnit, action)
    local evtKey = heventKeyMap.beSpilt
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--极限韧性抵抗
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
hevent.onLimitToughness = function(whichUnit, action)
    local evtKey = heventKeyMap.limitToughness
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--吸血时
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取目标单位
--- getDamage 获取吸血值
--- getPercent 获取吸血百分比
hevent.onHemophagia = function(whichUnit, action)
    local evtKey = heventKeyMap.hemophagia
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被吸血时
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
--- getDamage 获取吸血值
--- getPercent 获取吸血百分比
hevent.onBeHemophagia = function(whichUnit, action)
    local evtKey = heventKeyMap.beHemophagia
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--技能吸血时
--- getTriggerUnit 获取触发单位
--- getTargetUnit 获取目标单位
--- getDamage 获取吸血值
--- getPercent 获取吸血百分比
hevent.onSkillHemophagia = function(whichUnit, action)
    local evtKey = heventKeyMap.skillHemophagia
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被技能吸血时
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
--- getDamage 获取吸血值
--- getPercent 获取吸血百分比
hevent.onBeSkillHemophagia = function(whichUnit, action)
    local evtKey = heventKeyMap.beSkillHemophagia
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--硬直时
--- getTriggerUnit 获取触发单位
--- getSourceUnit 获取来源单位
--- getPercent 获取硬直程度百分比
--- getDuring 获取持续时间
hevent.onPunish = function(whichUnit, action)
    local evtKey = heventKeyMap.punish
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--死亡时
--- getTriggerUnit 获取触发单位
--- getKiller 获取凶手单位
hevent.onDead = function(whichUnit, action)
    local evtKey = heventKeyMap.dead
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--击杀时
--- getTriggerUnit 获取触发单位
--- getKiller 获取凶手单位
--- getTargetUnit 获取死亡单位
hevent.onKill = function(whichUnit, action)
    local evtKey = heventKeyMap.kill
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--复活时(必须使用 hunit.reborn 方法才能嵌入到事件系统)
--- getTriggerUnit 获取触发单位
hevent.onReborn = function(whichUnit, action)
    local evtKey = heventKeyMap.reborn
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--提升升等级时
--- getTriggerUnit 获取触发单位
hevent.onLevelUp = function(whichUnit, action)
    local evtKey = heventKeyMap.levelUp
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--被召唤时
--- getTriggerUnit 获取被召唤单位
hevent.onSummon = function(whichUnit, action)
    local evtKey = heventKeyMap.summon
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        bj.TriggerRegisterAnyUnitEventBJ(hRuntime.eventGlobalTgr[evtKey], EVENT_PLAYER_UNIT_SUMMON)
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--进入某单位（whichUnit）范围内
--- getTriggerUnit 获取被进入范围的中心单位
--- getTriggerEnterUnit 获取进入范围的单位
--- getRange 获取设定范围
hevent.onEnterUnitRange = function(whichUnit, range, action)
    local evtKey = heventKeyMap.enterUnitRange
    if (hRuntime.event[whichUnit].evtInit == nil) then
        hRuntime.event[whichUnit].evtInit = {}
    end
    if (hRuntime.event[whichUnit].evtInit[evtKey] == nil) then
        hRuntime.event[whichUnit].evtInit[evtKey] = true
        local tg = cj.CreateTrigger()
        cj.TriggerRegisterUnitInRangeSimple(tg, range, whichUnit)
        hRuntime.eventTgr[tg].triggerUnit = whichUnit
        hRuntime.eventTgr[tg].range = range
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
--离开某区域内
--- getTriggerRect 获取被离开的矩形区域
--- getTriggerUnit 获取离开矩形区域的单位
hevent.onEnterUnitRange = function(whichRect, action)
    local evtKey = heventKeyMap.leaveRect
    if (hRuntime.event[whichRect].evtInit == nil) then
        hRuntime.event[whichRect].evtInit = {}
    end
    if (hRuntime.event[whichRect].evtInit[evtKey] == nil) then
        hRuntime.event[whichRect].evtInit[evtKey] = true
        local tg = cj.CreateTrigger()
        cj.TriggerRegisterLeaveRectSimple(tg, whichRect)
        hRuntime.eventTgr[tg].triggerRect = whichRect
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
--当聊天时
--- params matchAll 是否全匹配，false为like
--- getTriggerPlayer 获取聊天的玩家
--- getTriggerString 获取聊天的内容
--- getTriggerStringMatched 获取匹配命中的内容
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
--按ESC
--- getTriggerPlayer 获取触发玩家
hevent.onEsc = function(whichPlayer, action)
    local evtKey = heventKeyMap.esc
    if (hRuntime.event[whichPlayer].evtInit == nil) then
        hRuntime.event[whichPlayer].evtInit = {}
    end
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            if (hRuntime.event[p].evtInit[evtKey] == nil) then
                hRuntime.event[p].evtInit[evtKey] = true
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
        if (hRuntime.event[whichPlayer].evtInit[evtKey] == nil) then
            hRuntime.event[whichPlayer].evtInit[evtKey] = true
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
--选择单位(基准)
--- 单选evtKey=selection1，双击=selection2，如此类推
hevent.onSelectionBindPlayer = function(whichPlayer, action, evtKey)
    if (hRuntime.event[whichPlayer].evtInit == nil) then
        hRuntime.event[whichPlayer].evtInit = {
            selectionBind = false,
            clickQty = 0,
        }
    end
    if (whichPlayer == nil) then
        return
    end
    if (hRuntime.eventGlobalTgr['selectionBind'] == nil) then
        hRuntime.eventGlobalTgr['selectionBind'] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr['selectionBind'], function()
            local triggerPlayer = cj.GetTriggerPlayer()
            local triggerUnit = cj.GetTriggerUnit()
            local qty = 1 + hRuntime.event[whichPlayer].evtInit.clickQty
            if (qty < 1) then
                qty = 1
            end
            qty = math.ceil(qty)
            hRuntime.event[whichPlayer].evtInit.clickQty = qty
            hevent.triggerEvent({
                triggerKey = heventKeyMap.selection .. qty,
                triggerPlayer = triggerPlayer,
                triggerUnit = triggerUnit,
            })
            htime.setTimeout(0.3, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                hRuntime.event[whichPlayer].evtInit.clickQty = hRuntime.event[whichPlayer].evtInit.clickQty - 1
            end)
        end)
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            hRuntime.event[cj.Player(i - 1)].evtInit = {
                selectionBind = false,
                clickQty = 0,
            }
        end
    end
    if (hRuntime.event[whichPlayer].evtInit.selectionBind == false) then
        hRuntime.event[whichPlayer].evtInit.selectionBind = true
        bj.TriggerRegisterPlayerSelectionEventBJ(hRuntime.eventGlobalTgr['selectionBind'], whichPlayer, true)
    end
    return hevent.onEventByHandleDefaultTrigger(evtKey, whichPlayer, action, hRuntime.eventGlobalTgr['selectionBind'])
end
hevent.onSelectionBind = function(whichPlayer, action, evtKey)
    if (whichPlayer ~= nil) then
        hevent.onSelectionBindPlayer(whichPlayer, action, evtKey)
    else
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            hevent.onSelectionBindPlayer(cj.Player(i - 1), action, evtKey)
        end
    end
    return hRuntime.eventGlobalTgr['selectionBind']
end
--玩家 N 击选择单位
--- whichPlayer 为nil时，指所有玩家
--- qty 需要点击次数
--- getTriggerPlayer 获取触发玩家
--- getTriggerUnit 获取触发单位
hevent.onSelection = function(whichPlayer, qty, action)
    return hevent.onSelectionBind(whichPlayer, action, heventKeyMap.selection .. qty)
end
hevent.onSelectionClear = function()
    hRuntime.eventGlobalTgr['selectionBind'] = nil
end
--玩家取消选择单位
--- getTriggerPlayer 获取触发玩家
--- getTriggerUnit 获取触发单位
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
            bj.TriggerRegisterPlayerSelectionEventBJ(tg, whichPlayer, false)
            hevent.onEventByHandle(evtKey, p, action)
        end
        return
    else
        bj.TriggerRegisterPlayerSelectionEventBJ(tg, whichPlayer, false)
        return hevent.onEventByHandle(evtKey, p, action)
    end
end
--建筑升级开始时
--- getTriggerUnit 获取触发单位
hevent.onUpgradeStart = function(whichUnit, action)
    local evtKey = heventKeyMap.upgradeStart
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(hRuntime.eventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_UPGRADE_START)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--建筑升级取消时
--- getTriggerUnit 获取触发单位
hevent.onUpgradeCancel = function(whichUnit, action)
    local evtKey = heventKeyMap.upgradeCancel
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(hRuntime.eventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_UPGRADE_CANCEL)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--建筑升级完成时
--- getTriggerUnit 获取触发单位
hevent.onUpgradeFinish = function(whichUnit, action)
    local evtKey = heventKeyMap.upgradeFinish
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    cj.TriggerRegisterUnitEvent(hRuntime.eventGlobalTgr[evtKey], whichUnit, EVENT_UNIT_UPGRADE_FINISH)
    return hevent.onEventByHandle(evtKey, whichUnit, action)
end
--任意建筑建造开始时
--- getTriggerUnit 获取触发单位
hevent.onConstructStart = function(whichPlayer, action)
    local evtKey = heventKeyMap.constructStart
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetTriggerUnit(),
            })
        end)
    end
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            cj.TriggerRegisterPlayerUnitEvent(hRuntime.eventGlobalTgr[evtKey], p, EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)
            hevent.onEventByHandleDefaultTrigger(evtKey, p, action, hRuntime.eventGlobalTgr[evtKey])
        end
        return
    else
        cj.TriggerRegisterPlayerUnitEvent(hRuntime.eventGlobalTgr[evtKey], whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_START, nil)
        return hevent.onEventByHandleDefaultTrigger(evtKey, whichPlayer, action, hRuntime.eventGlobalTgr[evtKey])
    end
end
--任意建筑建造取消时
--- getTriggerUnit 获取触发单位
hevent.onConstructCancel = function(whichPlayer, action)
    local evtKey = heventKeyMap.constructCancel
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetCancelledStructure(),
            })
        end)
    end
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            cj.TriggerRegisterPlayerUnitEvent(hRuntime.eventGlobalTgr[evtKey], p, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
            hevent.onEventByHandleDefaultTrigger(evtKey, p, action, hRuntime.eventGlobalTgr[evtKey])
        end
        return
    else
        cj.TriggerRegisterPlayerUnitEvent(hRuntime.eventGlobalTgr[evtKey], whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
        return hevent.onEventByHandleDefaultTrigger(evtKey, whichPlayer, action, hRuntime.eventGlobalTgr[evtKey])
    end
end
--任意建筑建造完成时
--- getTriggerUnit 获取触发单位
hevent.onConstructFinish = function(whichPlayer, action)
    local evtKey = heventKeyMap.constructFinish
    if (hRuntime.eventGlobalTgr[evtKey] == nil) then
        hRuntime.eventGlobalTgr[evtKey] = cj.CreateTrigger()
        cj.TriggerAddAction(hRuntime.eventGlobalTgr[evtKey], function()
            hevent.triggerEvent({
                triggerKey = evtKey,
                triggerUnit = cj.GetConstructedStructure(),
            })
        end)
    end
    if (whichPlayer == nil) then
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            cj.TriggerRegisterPlayerUnitEvent(hRuntime.eventGlobalTgr[evtKey], p, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
            hevent.onEventByHandleDefaultTrigger(evtKey, p, action, hRuntime.eventGlobalTgr[evtKey])
        end
        return
    else
        cj.TriggerRegisterPlayerUnitEvent(hRuntime.eventGlobalTgr[evtKey], whichPlayer, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil)
        return hevent.onEventByHandleDefaultTrigger(evtKey, whichPlayer, action, hRuntime.eventGlobalTgr[evtKey])
    end
end
--任意单位注册进h-lua系统时(注意这是全局事件)
--- getTriggerUnit 获取触发单位
hevent.onRegister = function(action)
    local evtKey = heventKeyMap.register
    return hevent.onEventByHandle(evtKey, hevent.defaultHandle, action)
end
--任意单位经过hero方法被玩家所挑选为英雄时(注意这是全局事件)
--- getTriggerPlayer 获取触发玩家
--- getTriggerUnit 获取触发单位
hevent.onPickHero = function(action)
    local evtKey = heventKeyMap.pickHero
    return hevent.onEventByHandle(evtKey, hevent.defaultHandle, action)
end

return hevent
