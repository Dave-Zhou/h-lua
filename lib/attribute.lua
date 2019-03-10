-- 属性系统
hattrCache = {}
hattrGroup = {
    life_back = {},
    mana_back = {},
    life_source = {},
    mana_source = {},
    punish = {},
}
hattr = {
    max_move_speed = 522,
    max_life = 999999999,
    max_mana = 999999999,
    min_life = 1,
    min_mana = 1,
    max_attack_range = 9999,
    min_attack_range = 0,
    default_attack_speed_space = 1.50,
    default_item_slot_ability = hsystem.getObjId('AInv'), -- 默认物品栏技能（英雄6格那个）默认认定这个技能为物品栏
    threeBuff = {
        --- 每一点三围对属性的影响，默认会写一些，可以通过 setThreeBuff 方法来改变系统构成
        --- 需要注意的是三围只能影响common内的大部分参数，natural及effect是无效的
        str = {
            life = 10, -- 每点力量提升10生命（默认例子）
            life_back = 0.1, -- 每点力量提升0.1生命恢复（默认例子）
        },
        agi = {
            attack_white = 1, -- 每点敏捷提升1白字攻击（默认例子）
            attack_speed = 0.02, -- 每点敏捷提升0.02攻击速度（默认例子）
        },
        int = {
            attack_green = 1, -- 每点智力提升1绿字攻击（默认例子）
            mana = 6, -- 每点智力提升6魔法（默认例子）
            mana_back = 0.05, -- 每点力量提升0.05生命恢复（默认例子）
        },
    },
}
--- 为单位添加N个同样的生命魔法技能 1级设0 2级设负 负减法（百度谷歌[卡血牌bug]，了解原理）
hattr.setLM = function(u, abilityId, qty)
    if (qty <= 0) then
        return
    end
    local i = 1
    while (i <= qty) do
        cj.UnitAddAbility(u, abilityId)
        cj.SetUnitAbilityLevel(u, abilityId, 2)
        cj.UnitRemoveAbility(u, abilityId)
        i = i + 1
    end
end
--- 为单位添加N个同样的视野技能
hattr.setSightAbility = function(u, abilityId, qty)
    if (qty <= 0) then
        return
    end
    local i = 1
    while (i <= qty) do
        cj.UnitAddAbility(u, abilityId)
        i = i + 1
    end
end
--- 为单位添加N个同样的攻击之书Private
hattr.setAttackWhitePrivate = function(u, itemId, qty)
    if (his.alive(u) == true) then
        local i = 1
        local it
        if (cj.GetUnitAbilityLevel(u, hattr.default_item_slot_ability) < 1) then
            cj.UnitAddAbility(u, hattr.default_item_slot_ability)
        end
        while (i <= qty) do
            it = cj.CreateItem(itemId, 0, 0)
            cj.UnitAddItem(u, it)
            cj.SetWidgetLife(it, 10.00)
            cj.RemoveItem(it)
            i = i + 1
        end
    else
        local per = 3.00
        local limit = 180.0 / per -- 一般不会超过3分钟复活
        htime.setInterval(per, nil, function(t, td)
            limit = limit - 1
            if (limit < 0) then
                htime.delDialog(td)
                htime.delTimer(t)
            elseif (his.alive(u) == true) then
                htime.delDialog(td)
                htime.delTimer(t)
                local i = 1
                local it
                if (cj.GetUnitAbilityLevel(u, hattr.default_item_slot_ability) < 1) then
                    cj.UnitAddAbility(u, hattr.default_item_slot_ability)
                end
                while (i <= qty) do
                    it = cj.CreateItem(itemId, 0, 0)
                    cj.UnitAddItem(u, it)
                    cj.SetWidgetLife(it, 10.00)
                    cj.RemoveItem(it)
                    i = i + 1
                end
            end
        end)
    end
end
--- 为单位添加N个同样的攻击之书
hattr.setAttackWhite = function(u, itemId, qty)
    if (u == nil or itemId == nil or qty <= 0) then
        return
    end
    hattr.setAttackWhitePrivate(u, itemId, qty)
end
--- 设置三围的影响
hattr.setThreeBuff = function(buff)
    if (type(buff) == 'table') then
        hattr.threeBuff = {
            str = {},
            agi = {},
            int = {},
        }
        for k, v in pairs(buff.str) do
            if (type(v) == 'number') then
                hattr.threeBuff.str[k] = v
            end
        end
        for k, v in pairs(buff.agi) do
            if (type(v) == 'number') then
                hattr.threeBuff.agi[k] = v
            end
        end
        for k, v in pairs(buff.int) do
            if (type(v) == 'number') then
                hattr.threeBuff.int[k] = v
            end
        end
    end
end
--- 为单位注册属性系统所需要的基础技能
--- hslk_global.attr
hattr.regAllAttrAbility = function(whichUnit)
    --生命魔法
    for k, ability in pairs(hslk_global.attr.life.add) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitRemoveAbility(whichUnit, ability)
    end
    for k, ability in pairs(hslk_global.attr.life.sub) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitRemoveAbility(whichUnit, ability)
    end
    for k, ability in pairs(hslk_global.attr.mana.add) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitRemoveAbility(whichUnit, ability)
    end
    for k, ability in pairs(hslk_global.attr.mana.sub) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitRemoveAbility(whichUnit, ability)
    end
    --物品栏
    if (cj.GetUnitAbilityLevel(whichUnit, hattr.default_item_slot_ability) < 1) then
        cj.UnitAddAbility(whichUnit, hattr.default_item_slot_ability)
        cj.UnitRemoveAbility(whichUnit, hattr.default_item_slot_ability)
    end
    --绿字攻击
    for k, ability in pairs(hslk_global.attr.attack_green.add) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    for k, ability in pairs(hslk_global.attr.attack_green.sub) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    --绿色属性
    for k, ability in pairs(hslk_global.attr.str_green.add) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    for k, ability in pairs(hslk_global.attr.str_green.sub) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    for k, ability in pairs(hslk_global.attr.agi_green.add) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    for k, ability in pairs(hslk_global.attr.agi_green.sub) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    for k, ability in pairs(hslk_global.attr.int_green.add) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    for k, ability in pairs(hslk_global.attr.int_green.sub) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    --攻击速度
    for k, ability in pairs(hslk_global.attr.attack_speed.add) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    for k, ability in pairs(hslk_global.attr.attack_speed.sub) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    --防御
    for k, ability in pairs(hslk_global.attr.defend.add) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    for k, ability in pairs(hslk_global.attr.defend.sub) do
        cj.UnitAddAbility(whichUnit, ability)
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
        cj.SetUnitAbilityLevel(whichUnit, ability, 1)
    end
    --白字攻击
    for k, ability in pairs(hslk_global.attr.attack_white.add) do
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
    end
    for k, ability in pairs(hslk_global.attr.attack_white.sub) do
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
    end
    --视野
    for k, ability in pairs(hslk_global.attr.sight.add) do
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
    end
    for k, ability in pairs(hslk_global.attr.sight.sub) do
        cj.UnitMakeAbilityPermanent(whichUnit, true, ability)
    end
    --物品拆分
    if (his.hero(whichUnit) == true) then
        cj.UnitAddAbility(whichUnit, hslk_global.ability_item_separate)
        cj.UnitMakeAbilityPermanent(whichUnit, true, hslk_global.ability_item_separate)
        cj.SetUnitAbilityLevel(whichUnit, hslk_global.ability_item_separate, 1)
    end
    --init
    local unitId = cj.GetUnitTypeId(whichUnit)
    hattrCache[whichUnit] = {
        primary = hslk_global.unitsKV[unitId].Primary,
        attack_type = {},
        common = {
            life = cj.GetUnitStateSwap(UNIT_STATE_MAX_LIFE, whichUnit),
            mana = cj.GetUnitStateSwap(UNIT_STATE_MAX_MANA, whichUnit),
            move = hslk_global.unitsKV[unitId].spd or cj.GetUnitDefaultMoveSpeed(whichUnit),
            defend = hslk_global.unitsKV[unitId].def or 0.0,
            attack_speed = 0.0,
            attack_speed_space = hslk_global.unitsKV[unitId].cool1 or hattr.default_attack_speed_space,
            attack_white = 0.0,
            attack_green = 0.0,
            attack_range = hslk_global.unitsKV[unitId].rangeN1 or 100.0,
            sight = hslk_global.unitsKV[unitId].sight or 800,
            str_green = 0.0,
            agi_green = 0.0,
            int_green = 0.0,
            str_white = cj.GetHeroStr(whichUnit, false),
            agi_white = cj.GetHeroAgi(whichUnit, false),
            int_white = cj.GetHeroInt(whichUnit, false),
            life_back = 0.0,
            life_source = 0.0,
            life_source_current = 0.0,
            mana_back = 0.0,
            mana_source = 0.0,
            mana_source_current = 0.0,
            resistance = 0.0,
            toughness = 0.0,
            avoid = 0.0,
            aim = 0.0,
            knocking = 0.0,
            violence = 0.0,
            punish = cj.GetUnitStateSwap(UNIT_STATE_MAX_LIFE, whichUnit) / 2,
            punish_current = cj.GetUnitStateSwap(UNIT_STATE_MAX_LIFE, whichUnit) / 2,
            meditative = 0.0,
            help = 0.0,
            hemophagia = 0.0,
            hemophagia_skill = 0.0,
            split = 0.0,
            split_range = 0.0,
            luck = 0.0,
            invincible = 0.0,
            weight = 0.0,
            weight_current = 0.0,
            hunt_amplitude = 0.0,
            hunt_rebound = 0.0,
            cure = 0.0,
            knocking_oppose = 0.0,
            violence_oppose = 0.0,
            hemophagia_oppose = 0.0,
            split_oppose = 0.0,
            punish_oppose = 0.0,
            hunt_rebound_oppose = 0.0,
            swim_oppose = 0.0,
            heavy_oppose = 0.0,
            break_oppose = 0.0,
            unluck_oppose = 0.0,
            silent_oppose = 0.0,
            unarm_oppose = 0.0,
            fetter_oppose = 0.0,
            bomb_oppose = 0.0,
            lightning_chain_oppose = 0.0,
            crack_fly_oppose = 0.0,
        },
        natural = {
            fire = 0.0,
            soil = 0.0,
            water = 0.0,
            ice = 0.0,
            wind = 0.0,
            light = 0.0,
            dark = 0.0,
            wood = 0.0,
            thunder = 0.0,
            poison = 0.0,
            ghost = 0.0,
            metal = 0.0,
            dragon = 0.0,
            fire_oppose = 0.0,
            soil_oppose = 0.0,
            water_oppose = 0.0,
            ice_oppose = 0.0,
            wind_oppose = 0.0,
            light_oppose = 0.0,
            dark_oppose = 0.0,
            wood_oppose = 0.0,
            thunder_oppose = 0.0,
            poison_oppose = 0.0,
            ghost_oppose = 0.0,
            metal_oppose = 0.0,
            dragon_oppose = 0.0,
        },
        effect = {
            life = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            mana = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            life_back = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            mana_back = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            life_source = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            mana_source = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            attack_speed = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            attack_white = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            attack_green = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            attack_range = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            defend = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            sight = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            move = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            aim = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            resistance = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            toughness = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            str_green = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            agt_green = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            int_green = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            str_white = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            agt_white = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            int_white = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            knocking = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            violence = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            hemophagia = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            hemophagia_skill = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            split = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            luck = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            hunt_amplitude = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            hunt_rebound = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            fire = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            soil = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            water = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            ice = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            wind = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            light = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            dark = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            wood = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            thunder = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            poison = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            ghost = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            metal = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            dragon = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            fire_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            soil_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            water_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            ice_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            wind_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            light_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            dark_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            wood_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            thunder_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            poison_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            ghost_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            metal_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            dragon_oppose = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            toxic = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            burn = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            dry = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            freeze = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            cold = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            blunt = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            myopia = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            muggle = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            blind = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            corrosion = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            chaos = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            twine = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            drunk = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            tortua = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            weak = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            astrict = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            foolish = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            dull = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            dirt = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            swim = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            heavy = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            broken = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            unluck = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            silent = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            unarm = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            fetter = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            bomb = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            lightning_chain = { odds = 0.0, val = 0.0, during = 0.0, model = nil, qty = 0, reduce = 0.0 },
            crack_fly = { odds = 0.0, val = 0.0, during = 0.0, model = nil, distance = 0, high = 0.0 },
        },
    }
    -- 智力英雄的攻击默认为魔法，力量敏捷为物理
    if (hattrCache[whichUnit].primary == 'INT') then
        hattrCache[whichUnit].attack_type = { 'magic' }
    else
        hattrCache[whichUnit].attack_type = { 'physical' }
    end
end
---设定攻击类型
hattr.setAttackType = function(whichUnit, attackType)
    if (hattrCache[whichUnit] == nil) then
        hattr.regAllAttrAbility(whichUnit)
    end
    if (type(attackType) ~= 'table') then
        print('attackType必须为table类型')
        return
    end
    hattrCache[whichUnit].attack_type = attackType
end
hattr.addAttackType = function(whichUnit, attackType)
    if (hattrCache[whichUnit] == nil) then
        hattr.regAllAttrAbility(whichUnit)
    end
    if (type(attackType) ~= 'string') then
        print('attackType必须为string类型')
        return
    end
    table.insert(hattrCache[whichUnit].attack_type, attackType)
end
hattr.subAttackType = function(whichUnit, attackType)
    if (hattrCache[whichUnit] == nil) then
        hattr.regAllAttrAbility(whichUnit)
    end
    if (type(attackType) ~= 'string') then
        print('attackType必须为string类型')
        return
    end
    hsystem.rmArray(attackType, hattrCache[whichUnit].attack_type, 1)
end
---设定基本属性(延时请用set/add/sub)
--[[
    白字攻击 绿字攻击
    攻速 视野 射程
    力敏智 力敏智(绿)
    护甲 魔抗
    活力 魔法 +恢复
    硬直
    物暴 术暴 分裂 回避 移动力 力量 敏捷 智力 救助力 吸血 负重 各率
]]
hattr.setCommon = function(flag, whichUnit, diff)
    if (hattrCache[whichUnit] == nil) then
        hattr.regAllAttrAbility(whichUnit)
    end
    if (hattrCache[whichUnit].common[flag] == nil) then
        print('暂不支持common = ' .. flag)
        return
    end
    if (flag ~= nil and whichUnit ~= nil and diff ~= 0) then
        local currentVal = 0
        local futureVal = 0
        local level = 0
        local tempVal = 0
        --- 生命 | 魔法
        if (flag == 'life' or mana) then
            currentVal = hattrCache[whichUnit].common[flag]
            futureVal = currentVal + diff
            hattrCache[whichUnit].common[flag] = futureVal
            if (futureVal >= hattr['max_' .. flag]) then
                if (currentVal >= hattr['max_' .. flag]) then
                    diff = 0
                else
                    diff = hattr['max_' .. flag] - currentVal
                end
            elseif (futureVal <= hattr['min_' .. flag]) then
                if (currentVal <= hattr['min_' .. flag]) then
                    diff = 0
                else
                    diff = hattr['min_' .. flag] - currentVal
                end
            end
            tempVal = math.floor(diff)
            local max = 100000000
            if (tempVal ~= 0) then
                if (diff < 0) then
                    tempVal = math.abs(tempVal);
                end
                while (max >= 1) do
                    level = math.floor(tempVal / max)
                    tempVal = math.floor(tempVal - level * max)
                    if (diff > 0) then
                        hattr.setLM(whichUnit, hslk_global.attr[flag].add[max], level)
                    else
                        hattr.setLM(whichUnit, hslk_global.attr[flag].sub[max], level)
                    end
                    max = math.floor(max / 10)
                end
            end
            return
        end
        --- 移动
        if (flag == 'move') then
            currentVal = hattrCache[whichUnit].common.move
            futureVal = currentVal + diff
            hattrCache[whichUnit].common.move = futureVal
            if (futureVal < 0) then
                cj.SetUnitMoveSpeed(whichUnit, 0)
            else
                if (hcamera.getModel(cj.GetOwningPlayer(whichUnit)) == "zoomin") then
                    cj.SetUnitMoveSpeed(whichUnit, math.floor(futureVal * 0.5))
                else
                    cj.SetUnitMoveSpeed(whichUnit, math.floor(futureVal))
                end
            end
            return
        end
        --- 白字攻击
        if (flag == 'attack_white') then
            currentVal = hattrCache[whichUnit].common.attack_white
            futureVal = currentVal + diff
            hattrCache[whichUnit].common.attack_white = futureVal
            if (futureVal > hattr.max_attack_white or futureVal < -hattr.max_attack_white) then
                diff = 0
            end
            tempVal = math.floor(diff)
            local max = 100000000
            if (tempVal ~= 0) then
                if (diff < 0) then
                    tempVal = math.abs(tempVal);
                end
                while (max >= 1) do
                    level = math.floor(tempVal / max)
                    tempVal = math.floor(tempVal - level * max)
                    if (diff > 0) then
                        hattr.setAttackWhite(whichUnit, hslk_global.attr.item_attack_white.add[max], level)
                    else
                        hattr.setAttackWhite(whichUnit, hslk_global.attr.item_attack_white.sub[max], level)
                    end
                    max = math.floor(max / 10)
                end
            end
            return
        end
        --- 攻击范围
        if (flag == 'attack_range') then
            currentVal = hattrCache[whichUnit].common.attack_range
            futureVal = currentVal + diff
            hattrCache[whichUnit].common.attack_range = futureVal
            if (futureVal < hattr.min_attack_range) then
                futureVal = hattr.min_attack_range
            elseif (futureVal > hattr.max_attack_range) then
                futureVal = hattr.max_attack_range
            end
            for k, ability in pairs(hslk_global.attr.attack_green.add) do
                cj.SetUnitAbilityLevel(whichUnit, ability, 1)
            end
            for k, ability in pairs(hslk_global.attr.attack_green.sub) do
                cj.SetUnitAbilityLevel(whichUnit, ability, 1)
            end
            if (hcamera.getModel(cj.GetOwningPlayer(whichUnit)) == "zoomin") then
                futureVal = futureVal * 0.5
            end
            cj.SetUnitAcquireRange(whichUnit, futureVal * 1.1)
            return
        end
        --- 视野
        if (flag == 'sight') then
            currentVal = hattrCache[whichUnit].common.sight
            futureVal = currentVal + diff
            hattrCache[whichUnit].common.sight = futureVal
            if (futureVal < -hattr.max_sight) then
                futureVal = -hattr.max_sight
            elseif (futureVal > hattr.max_sight) then
                futureVal = hattr.max_sight
            end
            for k, ability in pairs(hslk_global.attr.sight.add) do
                cj.UnitRemoveAbility(whichUnit, ability)
            end
            for k, ability in pairs(hslk_global.attr.sight.sub) do
                cj.UnitRemoveAbility(whichUnit, ability)
            end
            tempVal = math.floor(futureVal)
            local sightTotal = hsystem.cloneTable(hslk_global.attr.sightTotal)
            if (tempVal ~= 0) then
                if (diff < 0) then
                    tempVal = math.abs(tempVal);
                end
                while (true) do
                    local isFound = false
                    for k, v in pairs(sightTotal) do
                        if (tempVal >= v) then
                            tempVal = math.floor(tempVal - v)
                            hsystem.rmArray(v, sightTotal)
                            if (diff > 0) then
                                cj.UnitAddAbility(whichUnit, hslk_global.attr.sight.add[v])
                            else
                                cj.UnitAddAbility(whichUnit, hslk_global.attr.sight.sub[v])
                            end
                            isFound = true
                            break
                        end
                    end
                    if (isFound == false) then
                        break
                    end
                end
            end
            return
        end
        --- 绿字攻击 攻击速度 护甲
        if (hsystem.inArray(flag, { 'attack_green', 'attack_speed', 'defend' })) then
            currentVal = hattrCache[whichUnit].common[flag]
            futureVal = currentVal + diff
            hattrCache[whichUnit].common[flag] = futureVal
            if (futureVal < -99999999) then
                futureVal = -99999999
            elseif (futureVal > 99999999) then
                futureVal = 99999999
            end
            for k, ability in pairs(hslk_global.attr[flag].add) do
                cj.SetUnitAbilityLevel(whichUnit, ability, 1)
            end
            for k, ability in pairs(hslk_global.attr[flag].sub) do
                cj.SetUnitAbilityLevel(whichUnit, ability, 1)
            end
            tempVal = math.floor(futureVal)
            local max = 100000000
            if (tempVal ~= 0) then
                if (diff < 0) then
                    tempVal = math.abs(tempVal);
                end
                while (max >= 1) do
                    level = math.floor(tempVal / max)
                    tempVal = math.floor(tempVal - level * max)
                    if (diff > 0) then
                        cj.SetUnitAbilityLevel(whichUnit, hslk_global.attr[flag].add[max], level + 1)
                    else
                        cj.SetUnitAbilityLevel(whichUnit, hslk_global.attr[flag].sub[max], level + 1)
                    end
                    max = math.floor(max / 10)
                end
            end
            return
        end
        --- 绿字力量 绿字敏捷 绿字智力
        if (his.hero(whichUnit) and hsystem.inArray(flag, { 'str_green', 'agi_green', 'int_green' })) then
            currentVal = hattrCache[whichUnit].common[flag]
            futureVal = currentVal + diff
            hattrCache[whichUnit].common[flag] = futureVal
            if (futureVal < -99999999) then
                futureVal = -99999999
            elseif (futureVal > 99999999) then
                futureVal = 99999999
            end
            for k, ability in pairs(hslk_global.attr[flag].add) do
                cj.SetUnitAbilityLevel(whichUnit, ability, 1)
            end
            for k, ability in pairs(hslk_global.attr[flag].sub) do
                cj.SetUnitAbilityLevel(whichUnit, ability, 1)
            end
            tempVal = math.floor(futureVal)
            local max = 100000000
            if (tempVal ~= 0) then
                if (diff < 0) then
                    tempVal = math.abs(tempVal);
                end
                while (max >= 1) do
                    level = math.floor(tempVal / max)
                    tempVal = math.floor(tempVal - level * max)
                    if (diff > 0) then
                        cj.SetUnitAbilityLevel(whichUnit, hslk_global.attr[flag].add[max], level + 1)
                    else
                        cj.SetUnitAbilityLevel(whichUnit, hslk_global.attr[flag].sub[max], level + 1)
                    end
                    max = math.floor(max / 10)
                end
            end
            for k, v in pairs(hattr.threeBuff[string.gsub(flag, '_green')]) do
                hattr.setCommon(k, whichUnit, diff * v)
            end
            return
        end
        --- 白字力量 敏捷 智力
        if (his.hero(whichUnit) and hsystem.inArray(flag, { 'str_white', 'agi_white', 'int_white' })) then
            currentVal = hattrCache[whichUnit].common[flag]
            futureVal = currentVal + diff
            hattrCache[whichUnit].common[flag] = futureVal
            if (flag == 'str_white') then
                cj.SetHeroStr(whichUnit, math.floor(futureVal), true)
            elseif (flag == 'agi_white') then
                cj.SetHeroAgi(whichUnit, math.floor(futureVal), true)
            elseif (flag == 'int_white') then
                cj.SetHeroInt(whichUnit, math.floor(futureVal), true)
            end
            for k, v in pairs(hattr.threeBuff[string.gsub(flag, '_white')]) do
                hattr.setCommon(k, whichUnit, diff * v)
            end
            return
        end
        --- 生命恢复 魔法恢复
        if (flag == 'life_back' or flag == 'mana_back') then
            futureVal = hattrCache[whichUnit].common[flag] + diff
            hattrCache[whichUnit].common[flag] = futureVal
            if (math.abs(futureVal) > 0.02 and hsystem.inArray(whichUnit, hattrGroup[flag]) == false) then
                table.insert(hattrGroup[flag], whichUnit)
            elseif (math.abs(futureVal) < 0.02) then
                hsystem.rmArray(whichUnit, hattrGroup[flag])
            end
            return
        end
        --- 生命源 魔法源(current)
        if (flag == 'life_source_current' or flag == 'mana_source_current') then
            futureVal = hattrCache[whichUnit].common[flag] + diff
            local flagSource = string.gsub(flag, '_current', '', 1)
            if (futureVal > hattrCache[whichUnit].common[flagSource]) then
                futureVal = hattrCache[whichUnit].common[flagSource]
            end
            hattrCache[whichUnit].common[flag] = futureVal
            if (math.abs(futureVal) > 1 and hsystem.inArray(whichUnit, hattrGroup[flagSource]) == false) then
                table.insert(hattrGroup[flagSource], whichUnit)
            elseif (math.abs(futureVal) < 1) then
                hsystem.rmArray(whichUnit, hattrGroup[flagSource])
            end
            return
        end
        --- 硬直
        if (flag == 'punish' and hunit.isOpenPunish(whichUnit)) then
            currentVal = hattrCache[whichUnit].common[flag]
            futureVal = currentVal + diff
            hattrCache[whichUnit].common[flag] = futureVal
            if (currentVal > 0) then
                local tempPercent = futureVal / currentVal
                hattrCache[whichUnit].common.punish_current = tempPercent * hattrCache[whichUnit].common.punish_current
            else
                hattrCache[whichUnit].common.punish_current = futureVal
            end
            --- 硬直(current)
        elseif (flag == 'punish_current' and hunit.isOpenPunish(whichUnit)) then

        else
            hattrCache[whichUnit].common[flag] = hattrCache[whichUnit].common[flag] + diff
        end
    end
end
--- 自然(延时请用set/add/sub)
hattr.setNatural = function(flag, whichUnit, diff)
    if (hattrCache[whichUnit] == nil) then
        hattr.regAllAttrAbility(whichUnit)
    end
    if (hattrCache[whichUnit].natural[flag] == nil) then
        print('暂不支持natural = ' .. flag)
        return
    end
    if (diff ~= 0) then
        hattrCache[whichUnit].natural[flag] = hattrCache[whichUnit].natural[flag] + diff
    end
end
--- 伤害特效(延时请用set/add/sub)
--- data = { odds = 0.0, val = 0.0, during = 0.0, model = nil } example
hattr.setEffect = function(flag, whichUnit, data)
    if (hattrCache[whichUnit] == nil) then
        hattr.regAllAttrAbility(whichUnit)
    end
    if (hattrCache[whichUnit].effect[flag] == nil) then
        print('暂不支持effect = ' .. flag)
        return
    end
    for k, v in pairs(data) do
        if (type(hattrCache[whichUnit].effect[flag][k]) == 'number') then
            hattrCache[whichUnit].effect[flag][k] = hattrCache[whichUnit].effect[flag][k] + v
        else
            hattrCache[whichUnit].effect[flag][k] = v
        end
    end
end
--- 通用get
hattr.get = function(params)
    if (type(params) ~= 'table' or params.type == nil or params.whichUnit == nil) then
        return nil
    end
    if (hattrCache[params.whichUnit] == nil) then
        hattr.regAllAttrAbility(params.whichUnit)
    end
    if (params.type == 'attack_type') then
        return hattrCache[params.whichUnit].attack_type -- table
    elseif (params.type == 'common') then
        return hattrCache[params.whichUnit].common[params.flag] -- number
    elseif (params.type == 'natural') then
        return hattrCache[params.whichUnit].natural[params.flag] -- number
    elseif (params.type == 'effect') then
        return hattrCache[params.whichUnit].effect[params.flag] -- table
    end
    return nil
end
--- 通用set/add/sub
hattr.set = function(params)
    if (type(params) ~= 'table' or params.type == nil or params.flag == nil or params.whichUnit == nil or params.data == nil) then
        return
    end
    local diff
    local oldData
    if (params.type == 'attack_type' and type(params.data) == 'table') then
        oldData = hattr.get(params)
        hattr.setAttackType(params.whichUnit, params.data)
    elseif (params.type == 'common' and type(params.data) == 'number') then
        diff = params.data - hattr.get(params)
        hattr.setCommon(params.flag, params.whichUnit, diff)
    elseif (params.type == 'natural' and type(params.data) == 'number') then
        diff = params.data - hattr.get(params)
        hattr.setNatural(params.flag, params.whichUnit, diff)
    elseif (params.type == 'effect' and type(params.data) == 'table') then
        oldData = hattr.get(params)
        diff = hsystem.cloneTable(params.data)
        for k, v in pairs(oldData) do
            if (diff[k] ~= nil and type(oldData[k]) == 'number') then
                diff[k] = diff[k] - v
            end
        end
        hattr.setEffect(params.flag, params.whichUnit, diff)
    end
    if (type(params.during) == 'number' and params.during > 0) then
        htime.setTimeout(params.during, nil, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            if (params.type == 'attack_type' and type(params.data) == 'table') then
                hattr.setAttackType(params.whichUnit, oldData)
            elseif (params.type == 'common') then
                hattr.setCommon(params.flag, params.whichUnit, -diff)
            elseif (params.type == 'natural') then
                hattr.setNatural(params.flag, params.whichUnit, -diff)
            elseif (params.type == 'effect') then
                diff = hsystem.cloneTable(params.data)
                for k, v in pairs(oldData) do
                    if (diff[k] ~= nil and type(oldData[k]) == 'number') then
                        diff[k] = v - diff[k]
                    end
                end
                hattr.setEffect(params.flag, params.whichUnit, diff)
            end
        end)
    end
end
hattr.add = function(params)
    if (type(params) ~= 'table' or params.type == nil or params.flag == nil or params.whichUnit == nil or params.data == nil) then
        return
    end
    local oldData
    if (params.type == 'attack_type' and type(params.data) == 'string') then
        hattr.addAttackType(params.whichUnit, params.data)
    elseif (params.type == 'common' and type(params.data) == 'number') then
        hattr.setCommon(params.flag, params.whichUnit, params.data)
    elseif (params.type == 'natural' and type(params.data) == 'number') then
        hattr.setNatural(params.flag, params.whichUnit, params.data)
    elseif (params.type == 'effect' and type(params.data) == 'table') then
        oldData = hattr.get(params)
        hattr.setEffect(params.flag, params.whichUnit, params.data)
    end
    if (type(params.during) == 'number' and params.during > 0) then
        htime.setTimeout(params.during, nil, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            if (params.type == 'attack_type' and type(params.data) == 'string') then
                hattr.subAttackType(params.whichUnit, params.data)
            elseif (params.type == 'common') then
                hattr.setCommon(params.flag, params.whichUnit, -params.data)
            elseif (params.type == 'natural') then
                hattr.setNatural(params.flag, params.whichUnit, -params.data)
            elseif (params.type == 'effect') then
                for k, v in pairs(params.data) do
                    if (params.data[k] ~= nil and type(params.data[k]) == 'number') then
                        params.data[k] = -v
                    else
                        params.data[k] = oldData[k]
                    end
                end
                hattr.setEffect(params.flag, params.whichUnit, params.data)
            end
        end)
    end
end
hattr.sub = function(params)
    if (type(params) ~= 'table' or params.type == nil or params.flag == nil or params.whichUnit == nil or params.data == nil) then
        return
    end
    local diff
    local oldData
    if (params.type == 'attack_type' and type(params.data) == 'string') then
        hattr.subAttackType(params.whichUnit, params.data)
    elseif (params.type == 'common' and type(params.data) == 'number') then
        hattr.setCommon(params.flag, params.whichUnit, -params.data)
    elseif (params.type == 'natural' and type(params.data) == 'number') then
        hattr.setNatural(params.flag, params.whichUnit, -params.data)
    elseif (params.type == 'effect' and type(params.data) == 'table') then
        oldData = hattr.get(params)
        for k, v in pairs(params.data) do
            if (params.data[k] ~= nil and type(params.data[k]) == 'number') then
                diff[k] = -v
            end
        end
        hattr.setEffect(params.flag, params.whichUnit, diff)
    end
    if (type(params.during) == 'number' and params.during > 0) then
        htime.setTimeout(params.during, nil, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            if (params.type == 'attack_type' and type(params.data) == 'string') then
                hattr.subAttackType(params.whichUnit, params.data)
            elseif (params.type == 'common') then
                hattr.setCommon(params.flag, params.whichUnit, -params.data)
            elseif (params.type == 'natural') then
                hattr.setNatural(params.flag, params.whichUnit, -params.data)
            elseif (params.type == 'effect') then
                for k, v in pairs(params.data) do
                    if (params.data[k] ~= nil and type(params.data[k]) ~= 'number') then
                        params.data[k] = oldData[k]
                    end
                end
                hattr.setEffect(params.flag, params.whichUnit, params.data)
            end
        end)
    end
end

--todo 系统初始化
-- 单位受伤
local triggerBeHunt = cj.CreateTrigger()
cj.TriggerAddAction(triggerBeHunt, function()

end)
-- 单位死亡
local triggerDeath = cj.CreateTrigger()
cj.TriggerAddAction(triggerDeath, function()

end)
-- 单位进入区域注册
local triggerRegIn = cj.CreateTrigger()
cj.TriggerRegisterEnterRectSimple(triggerRegIn, cj.GetPlayableMapRect())
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
    if (hattrCache[u] == nil) then
        hattr.regAllAttrAbility(u)
        cj.TriggerRegisterUnitEvent(triggerBeHunt, u, EVENT_UNIT_DAMAGED)
        cj.TriggerRegisterUnitEvent(triggerDeath, u, EVENT_UNIT_DEATH)
        punishTtg(u)
        -- 拥有物品栏的单位绑定物品处理
        if (his.hasSlot(u)) then
            hitem.initUnit(u)
        end
        -- 触发注册事件(全局)
        hevent.triggerEvent({
            triggerKey = 'register',
            triggerHandle = hevent.defaultHandle,
            triggerUnit = u,
        })
    end
end)
-- 生命魔法恢复
htime.setInterval(0.50, nil, function(t,td)

end)
-- 硬直恢复
htime.setInterval(5.00, nil, function(t,td)

end)
-- 源恢复
htime.setInterval(25.00, nil, function(t,td)

end)