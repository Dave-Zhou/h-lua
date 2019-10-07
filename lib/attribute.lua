-- 属性系统

local hattr = {
    max_move_speed = 522,
    max_life = 999999999,
    max_mana = 999999999,
    min_life = 1,
    min_mana = 1,
    max_attack_range = 9999,
    min_attack_range = 0,
    default_attack_speed_space = 1.50,
    default_skill_item_slot = hSys.getObjId('AInv'), -- 默认物品栏技能（英雄6格那个）默认认定这个技能为物品栏
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
        if (cj.GetUnitAbilityLevel(u, hattr.default_skill_item_slot) < 1) then
            cj.UnitAddAbility(u, hattr.default_skill_item_slot)
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
                if (cj.GetUnitAbilityLevel(u, hattr.default_skill_item_slot) < 1) then
                    cj.UnitAddAbility(u, hattr.default_skill_item_slot)
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
hattr.regAllAbility = function(whichUnit)
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
    if (cj.GetUnitAbilityLevel(whichUnit, hattr.default_skill_item_slot) < 1) then
        cj.UnitAddAbility(whichUnit, hattr.default_skill_item_slot)
        cj.UnitRemoveAbility(whichUnit, hattr.default_skill_item_slot)
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
        cj.UnitAddAbility(whichUnit, hslk_global.skill_item_separate)
        cj.UnitMakeAbilityPermanent(whichUnit, true, hslk_global.skill_item_separate)
        cj.SetUnitAbilityLevel(whichUnit, hslk_global.skill_item_separate, 1)
    end
end
--- 为单位注册属性系统所需要的基础技能
--- hslk_global.attr
hattr.registerAll = function(whichUnit)
    hattr.regAllAbility(whichUnit)
    --init
    hSys.print_r(hslk_global.unitsKV)
    local unitId = hSys.getObjChar(cj.GetUnitTypeId(whichUnit))
    print(cj.GetUnitTypeId(whichUnit))
    print(unitId)
    hRuntime.attribute[whichUnit] = {
        primary = hslk_global.unitsKV[unitId].Primary,
        be_hunting = false,
        --
        life = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE),
        mana = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_MANA),
        move = hslk_global.unitsKV[unitId].spd or cj.GetUnitDefaultMoveSpeed(whichUnit),
        defend = hslk_global.unitsKV[unitId].def or 0.0,
        attack_hunt_type = {}, --- sp
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
        knocking_odds = 0.0,
        violence_odds = 0.0,
        punish = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE) / 2,
        punish_current = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE) / 2,
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
        hemophagia_skill_oppose = 0.0,
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
        natural_fire = 0.0,
        natural_soil = 0.0,
        natural_water = 0.0,
        natural_ice = 0.0,
        natural_wind = 0.0,
        natural_light = 0.0,
        natural_dark = 0.0,
        natural_wood = 0.0,
        natural_thunder = 0.0,
        natural_poison = 0.0,
        natural_ghost = 0.0,
        natural_metal = 0.0,
        natural_dragon = 0.0,
        natural_fire_oppose = 0.0,
        natural_soil_oppose = 0.0,
        natural_water_oppose = 0.0,
        natural_ice_oppose = 0.0,
        natural_wind_oppose = 0.0,
        natural_light_oppose = 0.0,
        natural_dark_oppose = 0.0,
        natural_wood_oppose = 0.0,
        natural_thunder_oppose = 0.0,
        natural_poison_oppose = 0.0,
        natural_ghost_oppose = 0.0,
        natural_metal_oppose = 0.0,
        natural_dragon_oppose = 0.0,
        --
        attack_buff = {}, -- array
        attack_debuff = {}, -- array
        skill_buff = {}, -- array
        skill_debuff = {}, -- array
        -- 特殊特效
        attack_effect = {
            swim = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            broken = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            silent = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            unarm = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            fetter = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            bomb = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            lightning_chain = { odds = 0.0, val = 0.0, during = 0.0, model = nil, qty = 0, reduce = 0.0 },
            crack_fly = { odds = 0.0, val = 0.0, during = 0.0, model = nil, distance = 0, high = 0.0 },
        },
        skill_effect = {
            swim = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            broken = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            silent = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            unarm = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            fetter = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            bomb = { odds = 0.0, val = 0.0, during = 0.0, model = nil, },
            lightning_chain = { odds = 0.0, val = 0.0, during = 0.0, model = nil, qty = 0, reduce = 0.0 },
            crack_fly = { odds = 0.0, val = 0.0, during = 0.0, model = nil, distance = 0, high = 0.0 },
        },
        --[[
            buff/debuff例子
            attack_buff = {
                攻击伤害时buff=20%几率增加自身 1.5% 的攻击速度 3 秒
                attack_speed = { odds = 20.0, val = 1.5, during = 3.0, model = nil },
            }
            skill_debuff = {
                技能伤害时buff=13%几率减少目标 3.5% 的攻击速度 4.4 秒，特效是 war3mapImported\\ExplosionBIG.mdl
                move = { odds = 13.0, val = 3.5, during = 4.4, model = 'war3mapImported\\ExplosionBIG.mdl' },
            }
        ]]
    }
    -- 智力英雄的攻击默认为魔法，力量敏捷为物理
    if (hRuntime.attribute[whichUnit].primary == 'INT') then
        hRuntime.attribute[whichUnit].attack_hunt_type = { 'magic' }
    else
        hRuntime.attribute[whichUnit].attack_hunt_type = { 'physical' }
    end
end

---设定属性
--[[
    白字攻击 绿字攻击
    攻速 视野 射程
    力敏智 力敏智(绿)
    护甲 魔抗
    活力 魔法 +恢复
    硬直
    物暴 术暴 分裂 回避 移动力 力量 敏捷 智力 救助力 吸血 负重 各率
    type(data) == table
    data = { 支持 加/减/乘/除/等
        life = '+100',
        mana = '-100',
        life_back = '*100',
        mana_back = '/100',
        move = '=100',
    }
    during = 0.0 大于0生效；小于等于0时无限持续时间
]]
hattr.setHandle = function(params, whichUnit, attr, opr, val, dur)
    if (type(val) == 'string') then
        -- string
        if (opr == '+') then
            table.insert(params[attr], val)
            if (dur > 0) then
                htime.setTimeout(dur, nil, function(t, td)
                    htime.delDialog(td)
                    htime.delTimer(t)
                    hattr.setHandle(params, whichUnit, attr, '-', val, 0)
                end)
            end
        elseif (opr == '-') then
            if (hSys.inArray(val, params[attr])) then
                hSys.rmArray(val, params[attr], 1)
                if (dur > 0) then
                    htime.setTimeout(dur, nil, function(t, td)
                        htime.delDialog(td)
                        htime.delTimer(t)
                        hattr.setHandle(params, whichUnit, attr, '+', val, 0)
                    end)
                end
            end
        elseif (opr == '=') then
            local old = hSys.cloneTable(params[attr])
            params[attr] = val
            if (dur > 0) then
                htime.setTimeout(dur, nil, function(t, td)
                    htime.delDialog(td)
                    htime.delTimer(t)
                    hattr.setHandle(params, whichUnit, attr, '=', old, 0)
                end)
            end
        end
    elseif (type(val) == 'number') then
        -- number
        local diff = 0
        if (opr == '+') then
            diff = val
        elseif (opr == '-') then
            diff = -val
        elseif (opr == '*') then
            diff = params[attr] * val - params[attr]
        elseif (opr == '/' and val ~= 0) then
            diff = params[attr] / val - params[attr]
        elseif (opr == '=') then
            diff = val - params[attr]
        end
        if (diff ~= 0) then
            local currentVal = params[attr]
            local futureVal = params[attr] + diff
            params[attr] = futureVal
            if (dur > 0) then
                htime.setTimeout(dur, nil, function(t, td)
                    htime.delDialog(td)
                    htime.delTimer(t)
                    hattr.setHandle(params, whichUnit, attr, '-', diff, 0)
                end)
            end
            -- ability
            local tempVal = 0
            local level = 0
            --- 生命 | 魔法
            if (attr == 'life' or attr == 'mana') then
                if (futureVal >= hattr['max_' .. attr]) then
                    if (currentVal >= hattr['max_' .. attr]) then
                        diff = 0
                    else
                        diff = hattr['max_' .. attr] - currentVal
                    end
                elseif (futureVal <= hattr['min_' .. attr]) then
                    if (currentVal <= hattr['min_' .. attr]) then
                        diff = 0
                    else
                        diff = hattr['min_' .. attr] - currentVal
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
                            hattr.setLM(whichUnit, hslk_global.attr[attr].add[max], level)
                        else
                            hattr.setLM(whichUnit, hslk_global.attr[attr].sub[max], level)
                        end
                        max = math.floor(max / 10)
                    end
                end
                --- 移动
            elseif (attr == 'move') then
                if (futureVal < 0) then
                    cj.SetUnitMoveSpeed(whichUnit, 0)
                else
                    if (hcamera.getModel(cj.GetOwningPlayer(whichUnit)) == "zoomin") then
                        cj.SetUnitMoveSpeed(whichUnit, math.floor(futureVal * 0.5))
                    else
                        cj.SetUnitMoveSpeed(whichUnit, math.floor(futureVal))
                    end
                end
                --- 白字攻击
            elseif (attr == 'attack_white') then
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
                --- 攻击范围
            elseif (attr == 'attack_range') then
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
                --- 视野
            elseif (attr == 'sight') then
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
                local sightTotal = hSys.cloneTable(hslk_global.attr.sightTotal)
                if (tempVal ~= 0) then
                    if (diff < 0) then
                        tempVal = math.abs(tempVal);
                    end
                    while (true) do
                        local isFound = false
                        for k, v in pairs(sightTotal) do
                            if (tempVal >= v) then
                                tempVal = math.floor(tempVal - v)
                                hSys.rmArray(v, sightTotal)
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
                --- 绿字攻击 攻击速度 护甲
            elseif (hSys.inArray(attr, { 'attack_green', 'attack_speed', 'defend' })) then
                if (futureVal < -99999999) then
                    futureVal = -99999999
                elseif (futureVal > 99999999) then
                    futureVal = 99999999
                end
                for k, ability in pairs(hslk_global.attr[attr].add) do
                    cj.SetUnitAbilityLevel(whichUnit, ability, 1)
                end
                for k, ability in pairs(hslk_global.attr[attr].sub) do
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
                            cj.SetUnitAbilityLevel(whichUnit, hslk_global.attr[attr].add[max], level + 1)
                        else
                            cj.SetUnitAbilityLevel(whichUnit, hslk_global.attr[attr].sub[max], level + 1)
                        end
                        max = math.floor(max / 10)
                    end
                end
                --- 绿字力量 绿字敏捷 绿字智力
            elseif (his.hero(whichUnit) and hSys.inArray(attr, { 'str_green', 'agi_green', 'int_green' })) then
                if (futureVal < -99999999) then
                    futureVal = -99999999
                elseif (futureVal > 99999999) then
                    futureVal = 99999999
                end
                for k, ability in pairs(hslk_global.attr[attr].add) do
                    cj.SetUnitAbilityLevel(whichUnit, ability, 1)
                end
                for k, ability in pairs(hslk_global.attr[attr].sub) do
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
                            cj.SetUnitAbilityLevel(whichUnit, hslk_global.attr[attr].add[max], level + 1)
                        else
                            cj.SetUnitAbilityLevel(whichUnit, hslk_global.attr[attr].sub[max], level + 1)
                        end
                        max = math.floor(max / 10)
                    end
                end
                local setting = {}
                for k, v in pairs(hattr.threeBuff[string.gsub(attr, '_green')]) do
                    setting[k] = '+' .. diff * v
                end
                hattr.set(whichUnit, 0, setting)
                --- 白字力量 敏捷 智力
            elseif (his.hero(whichUnit) and hSys.inArray(attr, { 'str_white', 'agi_white', 'int_white' })) then
                if (attr == 'str_white') then
                    cj.SetHeroStr(whichUnit, math.floor(futureVal), true)
                elseif (attr == 'agi_white') then
                    cj.SetHeroAgi(whichUnit, math.floor(futureVal), true)
                elseif (attr == 'int_white') then
                    cj.SetHeroInt(whichUnit, math.floor(futureVal), true)
                end
                local setting = {}
                for k, v in pairs(hattr.threeBuff[string.gsub(attr, '_white')]) do
                    setting[k] = '+' .. diff * v
                end
                hattr.set(whichUnit, 0, setting)
                --- 生命恢复 魔法恢复
            elseif (attr == 'life_back' or attr == 'mana_back') then
                if (math.abs(futureVal) > 0.02 and hSys.inArray(whichUnit, hRuntime.attributeGroup[attr]) == false) then
                    table.insert(hRuntime.attributeGroup[attr], whichUnit)
                elseif (math.abs(futureVal) < 0.02) then
                    hSys.rmArray(whichUnit, hRuntime.attributeGroup[attr])
                end
                --- 生命源 魔法源(current)
            elseif (attr == 'life_source_current' or attr == 'mana_source_current') then
                local attrSource = string.gsub(attr, '_current', '', 1)
                if (futureVal > hRuntime.attribute[whichUnit][attrSource]) then
                    futureVal = hRuntime.attribute[whichUnit][attrSource]
                    hRuntime.attribute[whichUnit][attr] = futureVal
                end
                if (math.abs(futureVal) > 1 and hSys.inArray(whichUnit, hRuntime.attributeGroup[attrSource]) == false) then
                    table.insert(hRuntime.attributeGroup[attrSource], whichUnit)
                elseif (math.abs(futureVal) < 1) then
                    hSys.rmArray(whichUnit, hRuntime.attributeGroup[attrSource])
                end
                --- 硬直
            elseif (attr == 'punish' and hunit.isOpenPunish(whichUnit)) then
                if (currentVal > 0) then
                    local tempPercent = futureVal / currentVal
                    hRuntime.attribute[whichUnit].punish_current = tempPercent * hRuntime.attribute[whichUnit].punish_current
                else
                    hRuntime.attribute[whichUnit].punish_current = futureVal
                end
                --- 硬直(current)
            elseif (attr == 'punish_current' and hunit.isOpenPunish(whichUnit)) then
                if (futureVal > hRuntime.attribute[whichUnit].punish) then
                    hRuntime.attribute[whichUnit].punish_current = hRuntime.attribute[whichUnit].punish
                end
            end
        end
    end
end
hattr.set = function(whichUnit, during, data)
    if (hRuntime.attribute[whichUnit] == nil) then
        hattr.registerAll(whichUnit)
    end
    -- 处理data
    if (type(data) ~= 'table') then
        print('data必须为table')
        return
    end
    for attr, v in pairs(data) do
        if (hRuntime.attribute[whichUnit][attr] ~= nil) then
            if (type(v) == 'string') then
                local opr = string.sub(v, 1, 1)
                v = string.sub(v, 2, string.len(v))
                local val = tonumber(v)
                if (val == nil) then
                    val = v
                end
                hattr.setHandle(hRuntime.attribute[whichUnit], whichUnit, attr, opr, val, during)
            elseif (type(v) == 'table') then
                -- 特效
                if (attr == 'attack_buff' or attr == 'attack_debuff' or attr == 'skill_buff' or attr == 'skill_debuff' or attr == 'attack_effect' or attr == 'skill_effect') then
                    for buff, bv in pairs(v) do
                        if (hRuntime.attribute[whichUnit][attr][buff] == nil) then
                            hRuntime.attribute[whichUnit][attr][buff] = {}
                        end
                        for effect, ev in pairs(bv) do
                            if (hRuntime.attribute[whichUnit][attr][buff][effect] == nil) then
                                hRuntime.attribute[whichUnit][attr][buff][effect] = {}
                            end
                            local opr = string.sub(ev, 1, 1)
                            ev = string.sub(ev, 2, string.len(ev))
                            local val = tonumber(ev)
                            if (val == nil) then
                                val = ev
                            end
                            hattr.setHandle(hRuntime.attribute[whichUnit][attr][buff], whichUnit, effect, opr, val, during)
                        end
                    end
                end
            end
        end
    end
end

--- 通用get
hattr.get = function(whichUnit, attr)
    if (whichUnit == nil or attr == nil) then
        return nil
    end
    if (hRuntime.attribute[whichUnit] == nil) then
        hattr.registerAll(whichUnit)
    end
    return hRuntime.attribute[whichUnit][attr]
end

---重置注册
hattr.reRegister = function(whichUnit)
    local life = hRuntime.attribute[whichUnit].life
    local mana = hRuntime.attribute[whichUnit].mana
    local move = hRuntime.attribute[whichUnit].move
    local strGreen = hRuntime.attribute[whichUnit].str_green
    local agiGreen = hRuntime.attribute[whichUnit].agi_green
    local intGreen = hRuntime.attribute[whichUnit].int_green
    local strWhite = hRuntime.attribute[whichUnit].str_white
    local agiWhite = hRuntime.attribute[whichUnit].agi_white
    local intWhite = hRuntime.attribute[whichUnit].int_white
    local attackWhite = hRuntime.attribute[whichUnit].attack_white
    local attackGreen = hRuntime.attribute[whichUnit].attack_green
    local attackSpeed = hRuntime.attribute[whichUnit].attack_speed
    local defend = hRuntime.attribute[whichUnit].defend
    -- 注册技能
    registerAll(whichUnit)
    -- 弥补属性
    cj.SetHeroStr(whichUnit, cj.R2I(strWhite), true)
    cj.SetHeroAgi(whichUnit, cj.R2I(agiWhite), true)
    cj.SetHeroInt(whichUnit, cj.R2I(intWhite), true)
    if (move < 0) then
        cj.SetUnitMoveSpeed(whichUnit, 0)
    else
        if (hcamera.model == "zoomin") then
            cj.SetUnitMoveSpeed(whichUnit, cj.R2I(move * 0.5))
        else
            cj.SetUnitMoveSpeed(whichUnit, cj.R2I(move))
        end
    end
    hRuntime.attribute[whichUnit].life = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE);
    hRuntime.attribute[whichUnit].mana = cj.GetUnitState(whichUnit, UNIT_STATE_MAX_MANA);
    hRuntime.attribute[whichUnit].defend = hslk_global.unitsKV[unitId].def or 0.0;
    hRuntime.attribute[whichUnit].attack_speed = 0;
    hRuntime.attribute[whichUnit].attack_white = 0;
    hRuntime.attribute[whichUnit].attack_green = 0;
    hRuntime.attribute[whichUnit].str_green = 0;
    hRuntime.attribute[whichUnit].agi_green = 0;
    hRuntime.attribute[whichUnit].int_green = 0;
    hattr.set(whichUnit, 0, {
        life = '+' .. (life - cj.GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE)),
        mana = '+' .. (mana - cj.GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE)),
        str_green = '+' .. strGreen,
        agi_green = '+' .. agiGreen,
        int_green = '+' .. intGreen,
        attack_white = '+' .. attackWhite,
        attack_green = '+' .. attackGreen,
        attack_speed = '+' .. attackSpeed,
        defend = '+' .. defend,
    })
end

--- 伤害一个单位
--[[
     * -bean.effect 伤害特效
     * -bean.huntKind伤害方式:
        attack 攻击
        skill 技能
        item 物品
        special 特殊（如眩晕、打断、分裂、爆炸、闪电链之类的）
     * -bean.huntType伤害类型:
        physical 物理伤害则无视护甲<享受物理暴击加成，受护甲影响>
        magic 魔法<享受魔法暴击加成，受魔抗影响>
        real 真实<无视回避>
        absolute 绝对(无视回避、无视无敌)
        fire    火
        soil    土
        water   水
        ice     冰
        wind    风
        light   光
        dark    暗
        wood    木
        thunder 雷
        poison  毒
        ghost   鬼
        metal   金
        dragon  龙
     * bean.breakArmorType 无视的类型：{ 'defend', 'resistance', 'avoid' }
     * 沉默时，爆炸、闪电链、击飞会失效，其他不受影响
]]
hattr.huntUnit = function(bean)
    local realDamage = 0
    local realDamagePercent = 0.0
    local realDamageString = ""
    local realDamageStringColor = "d9d9d9"
    local punishEffectRatio = 0
    local isAvoid = false
    local isKnocking = false
    local isViolence = false
    if (bean.damage <= 0.125) then
        print("伤害太小被忽略")
        return
    end
    if (bean.fromUnit == nil) then
        print("伤害源不存在")
        return
    end
    if (bean.toUnit == nil) then
        print("目标不存在")
        return
    end
    if (his.alive(bean.toUnit) == false) then
        print("目标已死亡")
        return
    end
    -- 判断伤害方式
    if (bean.huntKind == "attack") then
        if (his.unarm(bean.fromUnit) == true) then
            return
        end
        bean.huntType = hattr.get(bean.fromUnit, 'attack_hunt_type')
    elseif (bean.huntKind == "skill") then
        if (his.silent(bean.fromUnit) == true) then
            return
        end
    elseif (bean.huntKind == "item") then
    elseif (bean.huntKind == "special") then
    else
        print("伤害单位错误：huntKind")
        return
    end
    -- 计算单位是否无敌且伤害类型不混合绝对伤害（无敌属性为百分比计算，被动触发抵挡一次）
    if (his.invincible(bean.toUnit) == true or math.random(1, 100) < hattr.get(bean.toUnit, 'invincible')) then
        if (hSys.inArray('absolute', bean.huntType) == false) then
            return
        end
    end
    if (type(bean.huntEff) == 'string' and string.len(bean.huntEff) > 0) then
        heffect.toXY(bean.huntEff, cj.GetUnitX(bean.toUnit), cj.GetUnitY(bean.toUnit), 0)
    end
    -- 计算硬直抵抗
    punishEffectRatio = 0.99
    if (hattr.get(bean.toUnit, 'punish_oppose') > 0) then
        punishEffectRatio = punishEffectRatio - hattr.get(bean.toUnit, 'punish_oppose') * 0.01
        if (punishEffectRatio < 0.100) then
            punishEffectRatio = 0.100
        end
    end

    local toUnitDefend = hattr.get(bean.toUnit, 'defend')
    local toUnitResistance = hattr.get(bean.toUnit, 'resistance')
    local toUnitAvoid = hattr.get(bean.toUnit, 'avoid')
    local fromUnitKnocking = hattr.get(bean.fromUnit, 'knocking')
    local fromUnitViolence = hattr.get(bean.fromUnit, 'violence')
    local fromUnitKnockingOdds = hattr.get(bean.fromUnit, 'knocking_odds')
    local fromUnitViolenceOdds = hattr.get(bean.fromUnit, 'violence_odds')
    local fromUnitAim = hattr.get(bean.fromUnit, 'aim')
    local fromUnitHuntAmplitude = hattr.get(bean.fromUnit, 'hunt_amplitude')

    local toUnitKnockingOppose = hattr.get(bean.toUnit, 'knocking_oppose')
    local toUnitViolenceOppose = hattr.get(bean.toUnit, 'violence_oppose')

    -- *重要* hjass必须设定护甲因子为0，这里为了修正魔兽负护甲依然因子保持0.06的bug
    -- 当护甲x为负时，最大-20,公式2-(1-a)^abs(x)
    if (toUnitDefend < 0 and toUnitDefend >= -20) then
        bean.damage = bean.damage / (2 - cj.Pow(0.94, math.abs(toUnitDefend)))
    elseif (toUnitDefend < 0 and toUnitDefend < -20) then
        bean.damage = bean.damage / (2 - cj.Pow(0.94, 20))
    end
    -- 计算攻击者的攻击里物理攻击和魔法攻击的占比
    local attackSum = hattr.get(bean.fromUnit, 'attack_white') + hattr.get(bean.fromUnit, 'attack_green')
    local fromUnitHuntPercent = { physical = 0, magic = 0 }
    if (attackSum > 0) then
        fromUnitHuntPercent.physical = hattr.get(bean.fromUnit, 'attack_white') / attackSum
        fromUnitHuntPercent.magic = hattr.get(bean.fromUnit, 'attack_green') / attackSum
    end
    -- 赋值伤害
    realDamage = bean.damage
    -- 计算暴击值，判断伤害类型将暴击归0
    -- 判断无视装甲类型
    if (bean.breakArmorType) then
        realDamageString = realDamageString .. "无视"
        if (hSys.inArray('defend', bean.breakArmorType)) then
            if (toUnitDefend > 0) then
                toUnitDefend = 0
            end
            realDamageString = realDamageString .. "护甲"
            realDamageStringColor = "f97373"
        end
        if (hSys.inArray('resistance', bean.breakArmorType)) then
            if (toUnitResistance > 0) then
                toUnitResistance = 0
            end
            realDamageString = realDamageString .. "魔抗"
            realDamageStringColor = "6fa8dc"
        end
        if (hSys.inArray('avoid', bean.breakArmorType)) then
            toUnitAvoid = -100
            realDamageString = realDamageString .. "回避"
            realDamageStringColor = "76a5af"
        end
        -- @触发无视防御事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.breakArmor,
            triggerUnit = bean.fromUnit,
            targetUnit = bean.toUnit,
            breakType = bean.breakArmorType,
        })
        -- @触发被无视防御事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.beBreakArmor,
            triggerUnit = bean.toUnit,
            sourceUnit = bean.fromUnit,
            breakType = bean.breakArmorType,
        })
    end
    -- 如果遇到真实伤害，无法回避
    if (hSys.inArray("real", bean.huntType) == true) then
        toUnitAvoid = -99999
        realDamageString = realDamageString .. "真实"
    end
    -- 如果遇到绝对伤害，无法回避，无视无敌
    if (hSys.inArray("absolute", bean.huntType) == true) then
        toUnitAvoid = -99999
        realDamageString = realDamageString .. "绝对"
    end
    -- 计算物理暴击
    if (hSys.inArray("physical", bean.huntType) == true and (fromUnitKnockingOdds - toUnitKnockingOppose) > 0 and math.random(1, 100) <= (fromUnitKnockingOdds - toUnitKnockingOppose)) then
        realDamagePercent = realDamagePercent + fromUnitHuntPercent.physical * fromUnitKnocking * 0.01
        toUnitAvoid = -100 -- 触发暴击，回避减100%
        isKnocking = true
    end
    -- 计算魔法暴击
    if (hSys.inArray("magic", bean.huntType) == true and (fromUnitViolenceOdds - toUnitViolenceOppose) > 0 and math.random(1, 100) <= (fromUnitViolenceOdds - toUnitViolenceOppose)) then
        realDamagePercent = realDamagePercent + fromUnitHuntPercent.magic * fromUnitViolence * 0.01
        toUnitAvoid = -100 -- 触发暴击，回避减100%
        isViolence = true
    end
    -- 计算回避 X 命中
    if (bean.huntKind == "attack" and toUnitAvoid - fromUnitAim > 0 and math.random(1, 100) <= toUnitAvoid - fromUnitAim) then
        isAvoid = true
        realDamage = 0
        httg.style(httg.ttg2Unit(bean.toUnit, "回避", 6.00, "5ef78e", 10, 1.00, 10.00), "scale", 0, 0.2)
        -- @触发回避事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.avoid,
            triggerUnit = bean.toUnit,
            attacker = bean.fromUnit,
        })
        -- @触发被回避事件
        hevent.triggerEvent({
            triggerKey = heventKeyMap.beAvoid,
            triggerUnit = bean.fromUnit,
            attacker = bean.fromUnit,
            targetUnit = bean.toUnit,
        })
    end
    -- 计算自然属性
    if (realDamage > 0) then
        -- 自然属性
        local fromUnitNaturalFire = hattr.get(bean.fromUnit, 'natural_fire') - hattr.get(bean.toUnit, 'natural_fire_oppose') + 10
        local fromUnitNaturalSoil = hattr.get(bean.fromUnit, 'natural_soil') - hattr.get(bean.toUnit, 'natural_soi_loppose') + 10
        local fromUnitNaturalWater = hattr.get(bean.fromUnit, 'natural_water') - hattr.get(bean.toUnit, 'natural_water_oppose') + 10
        local fromUnitNaturalIce = hattr.get(bean.fromUnit, 'natural_ice') - hattr.get(bean.toUnit, 'natural_ice_oppose') + 10
        local fromUnitNaturalWind = hattr.get(bean.fromUnit, 'natural_wind') - hattr.get(bean.toUnit, 'natural_wind_oppose') + 10
        local fromUnitNaturalLight = hattr.get(bean.fromUnit, 'natural_light') - hattr.get(bean.toUnit, 'natural_light_oppose') + 10
        local fromUnitNaturalDark = hattr.get(bean.fromUnit, 'natural_dark') - hattr.get(bean.toUnit, 'natural_dark_oppose') + 10
        local fromUnitNaturalWood = hattr.get(bean.fromUnit, 'natural_wood') - hattr.get(bean.toUnit, 'natural_wood_oppose') + 10
        local fromUnitNaturalThunder = hattr.get(bean.fromUnit, 'natural_thunder') - hattr.get(bean.toUnit, 'natural_thunder_oppose') + 10
        local fromUnitNaturalPoison = hattr.get(bean.fromUnit, 'natural_poison') - hattr.get(bean.toUnit, 'natural_poison_oppose') + 10
        local fromUnitNaturalGhost = hattr.get(bean.fromUnit, 'natural_ghost') - hattr.get(bean.toUnit, 'natural_ghost_oppose') + 10
        local fromUnitNaturalMetal = hattr.get(bean.fromUnit, 'natural_metal') - hattr.get(bean.toUnit, 'natural_metal_oppose') + 10
        local fromUnitNaturalDragon = hattr.get(bean.fromUnit, 'natural_dragon') - hattr.get(bean.toUnit, 'natural_dragon_oppose') + 10
        if (fromUnitNaturalFire < -100) then
            fromUnitNaturalFire = -100
        end
        if (fromUnitNaturalSoil < -100) then
            fromUnitNaturalSoil = -100
        end
        if (fromUnitNaturalWater < -100) then
            fromUnitNaturalWater = -100
        end
        if (fromUnitNaturalIce < -100) then
            fromUnitNaturalIce = -100
        end
        if (fromUnitNaturalWind < -100) then
            fromUnitNaturalWind = -100
        end
        if (fromUnitNaturalLight < -100) then
            fromUnitNaturalLight = -100
        end
        if (fromUnitNaturalDark < -100) then
            fromUnitNaturalDark = -100
        end
        if (fromUnitNaturalWood < -100) then
            fromUnitNaturalWood = -100
        end
        if (fromUnitNaturalThunder < -100) then
            fromUnitNaturalThunder = -100
        end
        if (fromUnitNaturalPoison < -100) then
            fromUnitNaturalPoison = -100
        end
        if (fromUnitNaturalGhost < -100) then
            fromUnitNaturalGhost = -100
        end
        if (fromUnitNaturalMetal < -100) then
            fromUnitNaturalMetal = -100
        end
        if (fromUnitNaturalDragon < -100) then
            fromUnitNaturalDragon = -100
        end
        if (hSys.inArray('fire', bean.huntType) and fromUnitNaturalFire ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalFire * 0.01
            realDamageString = realDamageString .. "火"
            realDamageStringColor = "f45454"
        end
        if (hSys.inArray('soil', bean.huntType) and fromUnitNaturalSoil ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalSoil * 0.01
            realDamageString = realDamageString .. "土"
            realDamageStringColor = "dbb745"
        end
        if (hSys.inArray('water', bean.huntType) and fromUnitNaturalWater ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalWater * 0.01
            realDamageString = realDamageString .. "水"
            realDamageStringColor = "85adee"
        end
        if (hSys.inArray('ice', bean.huntType) and fromUnitNaturalIce ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalIce * 0.01
            realDamageString = realDamageString .. "冰"
            realDamageStringColor = "85f4f4"
        end
        if (hSys.inArray('wind', bean.huntType) and fromUnitNaturalWind ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalWind * 0.01
            realDamageString = realDamageString .. "风"
            realDamageStringColor = "b6d7a8"
        end
        if (hSys.inArray('light', bean.huntType) and fromUnitNaturalLight ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalLight * 0.01
            realDamageString = realDamageString .. "光"
            realDamageStringColor = "f9f99c"
        end
        if (hSys.inArray('dark', bean.huntType) and fromUnitNaturalDark ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalDark * 0.01
            realDamageString = realDamageString .. "暗"
            realDamageStringColor = "383434"
        end
        if (hSys.inArray('wood', bean.huntType) and fromUnitNaturalWood ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalWood * 0.01
            realDamageString = realDamageString .. "木"
            realDamageStringColor = "7cbd60"
        end
        if (hSys.inArray('thunder', bean.huntType) and fromUnitNaturalThunder ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalThunder * 0.01
            realDamageString = realDamageString .. "雷"
            realDamageStringColor = "7cbd60"
        end
        if (hSys.inArray('poison', bean.huntType) and fromUnitNaturalPoison ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalPoison * 0.01
            realDamageString = realDamageString .. "毒"
            realDamageStringColor = "45f7f7"
        end
        if (hSys.inArray('ghost', bean.huntType) and fromUnitNaturalGhost ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalGhost * 0.01
            realDamageString = realDamageString .. "鬼"
            realDamageStringColor = "383434"
        end
        if (hSys.inArray('metal', bean.huntType) and fromUnitNaturalMetal ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalMetal * 0.01
            realDamageString = realDamageString .. "金"
            realDamageStringColor = "f9f99c"
        end
        if (hSys.inArray('dragon', bean.huntType) and fromUnitNaturalDragon ~= 0) then
            realDamagePercent = realDamagePercent + fromUnitNaturalDragon * 0.01
            realDamageString = realDamageString .. "龙"
            realDamageStringColor = "7cbd60"
        end
    end
    -- 计算伤害增幅
    if (realDamage > 0 and fromUnitHuntAmplitude ~= 0) then
        realDamagePercent = realDamagePercent + fromUnitHuntAmplitude * 0.01
    end
    -- 计算混合了物理的杂乱伤害，护甲效果减弱
    if (hSys.inArray("physical", bean.huntType) and toUnitDefend > 0) then
        toUnitDefend = toUnitDefend * fromUnitHuntPercent.physical
        -- 计算护甲
        if (toUnitDefend > 0) then
            realDamagePercent = realDamagePercent - toUnitDefend / (toUnitDefend + 200)
        else
            realDamagePercent = realDamagePercent + -toUnitDefend / (-toUnitDefend + 100)
        end
    end
    -- 计算混合了魔法的杂乱伤害，魔抗效果减弱
    if (hSys.inArray("maigc", bean.huntType) and toUnitResistance > 0) then
        toUnitResistance = toUnitResistance * fromUnitHuntPercent.magic
        -- 计算魔抗
        if (toUnitResistance ~= 0) then
            if (toUnitResistance >= 100) then
                realDamagePercent = realDamagePercent * fromUnitHuntPercent.physical
            else
                realDamagePercent = realDamagePercent - toUnitResistance * 0.01
            end
        end
    end

    -- 合计 realDamagePercent
    realDamage = realDamage * (1 + realDamagePercent)

    -- 计算韧性
    local toUnitToughness = hattr.get(bean.toUnit, 'toughness')
    if (toUnitToughness > 0) then
        if ((realDamage - toUnitToughness) < realDamage * 0.1) then
            realDamage = realDamage * 0.1
            --@触发极限韧性抵抗事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.limitToughness,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
            })
        else
            realDamage = realDamage - toUnitToughness
        end
    end
    -- 上面都是先行计算 ------------------

    -- 造成伤害
    print("realDamage:" .. realDamage)
    if (realDamage > 0.25) then
        if (isKnocking) then
            --@触发物理暴击事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.knocking,
                triggerUnit = bean.fromUnit,
                targetUnit = bean.toUnit,
                damage = realDamage,
                value = fromUnitKnocking,
                percent = fromUnitKnockingOdds,
            })
            --@触发被物理暴击事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.beKnocking,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
                damage = realDamage,
                value = fromUnitKnocking,
                percent = fromUnitKnockingOdds,
            })
        end
        if (isViolence) then
            --@触发魔法暴击事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.violence,
                triggerUnit = bean.fromUnit,
                targetUnit = bean.toUnit,
                damage = realDamage,
                value = fromUnitViolence,
                percent = fromUnitViolenceOdds,
            })
            --@触发被魔法暴击事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.beViolence,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
                damage = realDamage,
                value = fromUnitViolence,
                percent = fromUnitViolenceOdds,
            })
        end
        -- 暴击文本加持
        if (isKnocking and isViolence) then
            realDamageString = realDamageString .. "双暴"
            realDamageStringColor = "b054ee"
        elseif (isKnocking) then
            realDamageString = realDamageString .. "物暴"
            realDamageStringColor = "ef3215"
        elseif (isViolence) then
            realDamageString = realDamageString .. "魔爆"
            realDamageStringColor = "15bcef"
        end
        -- 造成伤害
        hskill.damage({
            fromUnit = bean.fromUnit,
            toUnit = bean.toUnit,
            huntKind = bean.huntKind,
            huntType = bean.huntType,
            damage = realDamage,
            realDamage = bean.realDamage,
            realDamageString = realDamageString,
            realDamageStringColor = realDamageStringColor,
        })
        -- 分裂
        local split = hattr.get(bean.fromUnit, 'split') - hattr.get(bean.toUnit, 'split_oppose')
        local split_range = hattr.get(bean.fromUnit, 'split_range')
        if (bean.huntKind == "attack" and split > 0) then
            local g = hgroup.createByUnit(bean.toUnit, split_range, function()
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
                return flag
            end)
            heffect.toUnit("Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl", bean.toUnit, 0)
            cj.ForGroup(g, function()
                local u = cj.GetEnumUnit()
                if (u ~= bean.toUnit) then
                    -- 造成伤害
                    hskill.damage({
                        fromUnit = bean.fromUnit,
                        toUnit = u,
                        huntKind = 'special',
                        huntType = { "real" },
                        damage = realDamage * split * 0.01,
                        realDamage = realDamage * split * 0.01,
                        realDamageString = '分裂',
                        realDamageStringColor = 'e25746',
                    })
                    heffect.toUnit("Abilities\\Spells\\Other\\Cleave\\CleaveDamageTarget.mdl", u, 0)
                end
            end)
            cj.GroupClear(g)
            cj.DestroyGroup(g)
            -- @触发分裂事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.split,
                triggerUnit = bean.fromUnit,
                targetUnit = bean.toUnit,
                damage = realDamage * split * 0.01,
                range = split_range,
                percent = split,
            })
            -- @触发被分裂事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.beSpilt,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
                damage = realDamage * split * 0.01,
                range = split_range,
                percent = split,
            })
        end
        -- 吸血
        local hemophagia = hattr.get(bean.toUnit, 'hemophagia') - hattr.get(bean.toUnit, 'hemophagia_oppose')
        if (bean.huntKind == "attack" and hemophagia > 0) then
            hunit.addLife(bean.fromUnit, realDamage * hemophagia * 0.01)
            heffect.toUnit("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl", bean.fromUnit, "origin", 1.00)
            -- @触发吸血事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.hemophagia,
                triggerUnit = bean.fromUnit,
                targetUnit = bean.toUnit,
                damage = realDamage * hemophagia * 0.01,
                percent = hemophagia
            })
            -- @触发被吸血事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.beHemophagia,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
                damage = realDamage * hemophagia * 0.01,
                percent = hemophagia
            })
        end
        -- 技能吸血
        local hemophagia_skill = hattr.get(bean.toUnit, 'hemophagia_skill') - hattr.get(bean.toUnit, 'hemophagia_skill_oppose')
        if (bean.huntKind == "skill" and hemophagia_skill > 0) then
            hunit.addLife(bean.fromUnit, realDamage * hemophagia_skill * 0.01)
            heffect.toUnit("Abilities\\Spells\\Items\\HealingSalve\\HealingSalveTarget.mdl", bean.fromUnit, "origin", 1.80)
            -- @触发技能吸血事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.skillHemophagia,
                triggerUnit = bean.fromUnit,
                targetUnit = bean.toUnit,
                damage = realDamage * hemophagia_skill * 0.01,
                percent = hemophagia_skill
            })
            -- @触发被技能吸血事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.beSkillHemophagia,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
                damage = realDamage * hemophagia_skill * 0.01,
                percent = hemophagia_skill
            })
        end
        -- 硬直
        local punish_during = 5.00
        if (realDamage > 3 and his.alive(bean.toUnit) and his.punish(bean.toUnit) == false and hunit.isOpenPunish(bean.toUnit)) then
            hattr.set(bean.toUnit, 0, {
                punish_current = '-' .. realDamage
            })
            if (hattr.get(bean.toUnit, 'punish_current') <= 0) then
                hRuntime.is[bean.toUnit].isPunishing = true
                htime.setTimeout(punish_during + 1.00, nil, function(t, td)
                    htime.delDialog(td)
                    htime.delTimer(t)
                    hRuntime.is[bean.toUnit].isPunishing = false
                end)
            end
            local punishEffectAttackSpeed = (100 + hattr.get(bean.toUnit, 'attack_speed')) * punishEffectRatio
            local punishEffectMove = hattr.get(bean.toUnit, 'move') * punishEffectRatio
            if (punishEffectAttackSpeed < 1) then
                punishEffectAttackSpeed = 1.00
            end
            if (punishEffectMove < 1) then
                punishEffectMove = 1.00
            end
            hattr.set(bean.toUnit, punish_during, {
                attack_speed = '-' .. punishEffectAttackSpeed,
                move = '-' .. punishEffectMove,
            })
            httg.style(httg.create2Unit(bean.toUnit, "僵硬", 6.00, "c0c0c0", 0, punish_during, 50.00), "scale", 0, 0)
            -- @触发硬直事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.heavy,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
                percent = punishEffectRatio * 100,
                during = punish_during,
            })
        end
        -- 反射
        local toUnitHuntRebound = hattr.get(bean.toUnit, 'hunt_rebound') - hattr.get(bean.fromUnit, 'hunt_rebound_oppose')
        if (toUnitHuntRebound > 0) then
            hunit.subLife(bean.fromUnit, realDamage * toUnitHuntRebound * 0.01)
            httg.style(httg.create2Unit(bean.fromUnit, "反伤" .. (realDamage * toUnitHuntRebound * 0.01), 10.00, "f8aaeb", 10, 1.00, 10.00), "shrink", -0.05, 0)
            -- @触发反伤事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.rebound,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
                damage = realDamage * toUnitHuntRebound * 0.01,
            })
        end
        -- 特殊效果,需要非无敌并处于效果启动状态下
        -- buff/debuff
        local attackBuff = hattr.get(bean.fromUnit, 'attack_buff')
        local attackDebuff = hattr.get(bean.fromUnit, 'attack_debuff')
        local skillBuff = hattr.get(bean.fromUnit, 'skill_buff')
        local skillDebuff = hattr.get(bean.fromUnit, 'skill_debuff')
        if (bean.huntKind == 'attack') then
            for k, b in pairs(attackBuff) do
                if (b.val ~= 0 and b.during > 0 and math.random(1, 100) <= b.odds) then
                    hattr.set(bean.fromUnit, b.during, { k = '+' .. b.val })
                    if (type(b.model) == 'string' and string.len(b.model) > 0) then
                        heffect.toUnit(b.model, bean.fromUnit, "origin", b.during)
                    end
                end
            end
            for k, b in pairs(attackDebuff) do
                if (b.val ~= 0 and b.during > 0 and math.random(1, 100) <= b.odds) then
                    hattr.set(bean.fromUnit, b.during, { k = '-' .. b.val })
                    if (type(b.model) == 'string' and string.len(b.model) > 0) then
                        heffect.toUnit(b.model, bean.fromUnit, "origin", b.during)
                    end
                end
            end
        end
        if (bean.huntKind == 'skill') then
            for k, b in pairs(skillBuff) do
                if (b.val ~= 0 and b.during > 0 and math.random(1, 100) <= b.odds) then
                    hattr.set(bean.fromUnit, b.during, { k = '+' .. b.val })
                    if (type(b.model) == 'string' and string.len(b.model) > 0) then
                        heffect.toUnit(b.model, bean.fromUnit, "origin", b.during)
                    end
                end
            end
            for k, b in pairs(skillDebuff) do
                if (b.val ~= 0 and b.during > 0 and math.random(1, 100) <= b.odds) then
                    hattr.set(bean.fromUnit, b.during, { k = '-' .. b.val })
                    if (type(b.model) == 'string' and string.len(b.model) > 0) then
                        heffect.toUnit(b.model, bean.fromUnit, "origin", b.during)
                    end
                end
            end
        end
        -- effect
        local attackEffect = hattr.get(bean.fromUnit, 'attack_effect')
        local skillEffect = hattr.get(bean.fromUnit, 'skill_effect')
        -- 眩晕 swim
        -- flag
        local isSwim = false
        local isBroken = false
        local isSilent = false
        local isUnarm = false
        local isFetter = false
        local isBomb = false
        local isLightningChain = false
        local isCrackFly = false
        -- data
        local swimEffect = {
            attack = hSys.cloneTable(attackEffect.swim),
            skill = hSys.cloneTable(skillEffect.swim),
        }
        local brokenEffect = {
            attack = hSys.cloneTable(attackEffect.broken),
            skill = hSys.cloneTable(skillEffect.broken),
        }
        local silentEffect = {
            attack = hSys.cloneTable(attackEffect.silent),
            skill = hSys.cloneTable(skillEffect.silent),
        }
        local unarmEffect = {
            attack = hSys.cloneTable(attackEffect.unarm),
            skill = hSys.cloneTable(skillEffect.unarm),
        }
        local fetterEffect = {
            attack = hSys.cloneTable(attackEffect.fetter),
            skill = hSys.cloneTable(skillEffect.fetter),
        }
        local bombEffect = {
            attack = hSys.cloneTable(attackEffect.bomb),
            skill = hSys.cloneTable(skillEffect.bomb),
        }
        local lightningChainEffect = {
            attack = hSys.cloneTable(attackEffect.lightning_chain),
            skill = hSys.cloneTable(skillEffect.lightning_chain),
        }
        local crackFlyEffect = {
            attack = hSys.cloneTable(attackEffect.lightning_chain),
            skill = hSys.cloneTable(skillEffect.lightning_chain),
        }
        -- oppose
        local swimOppose = hattr.get(bean.toUnit, 'swim_oppose')
        local brokenOppose = hattr.get(bean.toUnit, 'broken_oppose')
        local silentOppose = hattr.get(bean.toUnit, 'silent_oppose')
        local unarmOppose = hattr.get(bean.toUnit, 'unarm_oppose')
        local fetterOppose = hattr.get(bean.toUnit, 'fetter_oppose')
        local bombOppose = hattr.get(bean.toUnit, 'bomb_oppose')
        local lightningChainOppose = hattr.get(bean.toUnit, 'lightning_chain_oppose')
        local crackFlyOppose = hattr.get(bean.toUnit, 'crack_fly')

        if (bean.huntKind == 'attack') then
            swimEffect.attack.odds = swimEffect.attack.odds * (1 - swimOppose * 0.01)
            swimEffect.attack.during = swimEffect.attack.during * (1 - swimOppose * 0.01)
            swimEffect.attack.val = swimEffect.attack.val * (1 - swimOppose * 0.01)
            brokenEffect.attack.odds = brokenEffect.attack.odds * (1 - brokenOppose * 0.01)
            brokenEffect.attack.val = brokenEffect.attack.val * (1 - brokenOppose * 0.01)
            silentEffect.attack.odds = silentEffect.attack.odds * (1 - silentOppose * 0.01)
            silentEffect.attack.during = silentEffect.attack.during * (1 - silentOppose * 0.01)
            silentEffect.attack.val = silentEffect.attack.val * (1 - silentOppose * 0.01)
            unarmEffect.attack.odds = unarmEffect.attack.odds * (1 - unarmOppose * 0.01)
            unarmEffect.attack.during = unarmEffect.attack.during * (1 - unarmOppose * 0.01)
            unarmEffect.attack.val = unarmEffect.attack.val * (1 - unarmOppose * 0.01)
            fetterEffect.attack.odds = fetterEffect.attack.odds * (1 - fetterOppose * 0.01)
            fetterEffect.attack.during = fetterEffect.attack.during * (1 - fetterOppose * 0.01)
            fetterEffect.attack.val = fetterEffect.attack.val * (1 - fetterOppose * 0.01)
            bombEffect.attack.odds = bombEffect.attack.odds * (1 - bombOppose * 0.01)
            bombEffect.attack.val = bombEffect.attack.val * (1 - bombOppose * 0.01)
            lightningChainEffect.attack.odds = lightningChainEffect.attack.odds * (1 - lightningChainOppose * 0.01)
            lightningChainEffect.attack.val = lightningChainEffect.attack.val * (1 - lightningChainOppose * 0.01)
            crackFlyEffect.attack.odds = crackFlyEffect.attack.odds * (1 - crackFlyOppose * 0.01)
            crackFlyEffect.attack.val = crackFlyEffect.attack.val * (1 - crackFlyOppose * 0.01)
            --
            if (swimEffect.attack.odds > 0 and swimEffect.attack.during >= 0.01 and Math.random(1, 100) <= swimEffect.attack.odds) then
                isSwim = true
            end
            if (brokenEffect.attack.odds > 0 and Math.random(1, 100) <= brokenEffect.attack.odds) then
                isBroken = true
            end
            if (silentEffect.attack.odds > 0 and silentEffect.attack.during >= 0.01 and Math.random(1, 100) <= silentEffect.attack.odds) then
                isSilent = true
            end
            if (unarmEffect.attack.odds > 0 and unarmEffect.attack.during >= 0.01 and Math.random(1, 100) <= unarmEffect.attack.odds) then
                isUnarm = true
            end
            if (fetterEffect.attack.odds > 0 and fetterEffect.attack.during >= 0.01 and Math.random(1, 100) <= fetterEffect.attack.odds) then
                isFetter = true
            end
            if (bombEffect.attack.odds > 0 and Math.random(1, 100) <= bombEffect.attack.odds) then
                isBomb = true
            end
            if (lightningChainEffect.attack.odds > 0 and lightningChainEffect.attack.qty > 0 and Math.random(1, 100) <= lightningChainEffect.attack.odds) then
                isLightningChain = true
            end
            if (crackFlyEffect.attack.odds > 0 and (crackFlyEffect.attack.distance > 0 or crackFlyEffect.attack.high > 0) and Math.random(1, 100) <= crackFlyEffect.attack.odds) then
                isCrackFly = true
            end
        end
        if (bean.huntKind == 'skill') then
            swimEffect.skill.odds = swimEffect.skill.odds * (1 - swimOppose * 0.01)
            swimEffect.skill.during = swimEffect.skill.during * (1 - swimOppose * 0.01)
            swimEffect.skill.val = swimEffect.skill.val * (1 - swimOppose * 0.01)
            brokenEffect.skill.odds = brokenEffect.skill.odds * (1 - brokenOppose * 0.01)
            brokenEffect.skill.val = brokenEffect.skill.val * (1 - brokenOppose * 0.01)
            silentEffect.skill.odds = silentEffect.skill.odds * (1 - silentOppose * 0.01)
            silentEffect.skill.during = silentEffect.skill.during * (1 - silentOppose * 0.01)
            silentEffect.skill.val = silentEffect.skill.val * (1 - silentOppose * 0.01)
            unarmEffect.skill.odds = unarmEffect.skill.odds * (1 - unarmOppose * 0.01)
            unarmEffect.skill.during = unarmEffect.skill.during * (1 - unarmOppose * 0.01)
            unarmEffect.skill.val = unarmEffect.skill.val * (1 - unarmOppose * 0.01)
            fetterEffect.skill.odds = fetterEffect.skill.odds * (1 - fetterOppose * 0.01)
            fetterEffect.skill.during = fetterEffect.skill.during * (1 - fetterOppose * 0.01)
            fetterEffect.skill.val = fetterEffect.skill.val * (1 - fetterOppose * 0.01)
            bombEffect.skill.odds = bombEffect.skill.odds * (1 - bombOppose * 0.01)
            bombEffect.skill.val = bombEffect.skill.val * (1 - bombOppose * 0.01)
            lightningChainEffect.skill.odds = lightningChainEffect.skill.odds * (1 - lightningChainOppose * 0.01)
            lightningChainEffect.skill.val = lightningChainEffect.skill.val * (1 - lightningChainOppose * 0.01)
            crackFlyEffect.skill.odds = crackFlyEffect.skill.odds * (1 - crackFlyOppose * 0.01)
            crackFlyEffect.skill.val = crackFlyEffect.skill.val * (1 - crackFlyOppose * 0.01)
            --
            if (swimEffect.skill.odds > 0 and swimEffect.skill.during >= 0.01 and Math.random(1, 100) <= swimEffect.skill.odds) then
                isSwim = true
            end
            if (brokenEffect.skill.odds > 0 and Math.random(1, 100) <= brokenEffect.skill.odds) then
                isBroken = true
            end
            if (silentEffect.skill.odds > 0 and silentEffect.skill.during >= 0.01 and Math.random(1, 100) <= silentEffect.skill.odds) then
                isSilent = true
            end
            if (unarmEffect.skill.odds > 0 and unarmEffect.skill.during >= 0.01 and Math.random(1, 100) <= unarmEffect.skill.odds) then
                isUnarm = true
            end
            if (fetterEffect.skill.odds > 0 and fetterEffect.skill.during >= 0.01 and Math.random(1, 100) <= fetterEffect.skill.odds) then
                isFetter = true
            end
            if (bombEffect.skill.odds > 0 and Math.random(1, 100) <= bombEffect.skill.odds) then
                isBomb = true
            end
            if (lightningChainEffect.skill.odds > 0 and lightningChainEffect.skill.qty > 0 and Math.random(1, 100) <= lightningChainEffect.skill.odds) then
                isLightningChain = true
            end
            if (crackFlyEffect.skill.odds > 0 and (crackFlyEffect.skill.distance > 0 or crackFlyEffect.skill.high > 0) and Math.random(1, 100) <= crackFlyEffect.skill.odds) then
                isCrackFly = true
            end
        end
        -- 眩晕
        if (isSwim) then
            hskill.swim(bean.toUnit, swimEffect.during, bean.fromUnit, swimEffect.val, swimEffect.odds)
            if (swimEffect.val > 0) then
                hskill.damage({
                    fromUnit = bean.fromUnit,
                    toUnit = bean.toUnit,
                    damage = swimEffect.val,
                    realDamage = swimEffect.val,
                    realDamageString = '眩晕',
                    huntKind = "special",
                    huntType = { "real" },
                })
            end
            if (swimEffect.model ~= nil) then
                heffect.toUnit(swimEffect.model, bean.toUnit, "origin", 0.5)
            end
        end
        -- 打断
        if (isBroken) then
            hskill.broken(bean.toUnit, bean.fromUnit, brokenEffect.val, brokenEffect.odds)
            if (brokenEffect.val > 0) then
                hskill.damage({
                    fromUnit = bean.fromUnit,
                    toUnit = bean.toUnit,
                    damage = brokenEffect.val,
                    realDamage = brokenEffect.val,
                    realDamageString = '打断',
                    huntKind = "special",
                    huntType = { "real" },
                })
            end
            if (brokenEffect.model ~= nil) then
                heffect.toUnit(brokenEffect.model, bean.toUnit, "origin", 0.5)
            end
        end
        -- 沉默
        if (isSilent) then
            hskill.silent(bean.toUnit, silentEffect.during, bean.fromUnit, silentEffect.val, silentEffect.odds)
            if (silentEffect.val > 0) then
                hskill.damage({
                    fromUnit = bean.fromUnit,
                    toUnit = bean.toUnit,
                    damage = silentEffect.val,
                    realDamage = silentEffect.val,
                    realDamageString = '沉默',
                    huntKind = "special",
                    huntType = { "magic" },
                })
            end
            if (silentEffect.model ~= nil) then
                heffect.toUnit(silentEffect.model, bean.toUnit, "origin", 0.5)
            end
        end
        -- 缴械
        if (isUnarm) then
            hskill.unarm(bean.toUnit, unarmEffect.during, bean.fromUnit, unarmEffect.val, unarmEffect.odds)
            if (unarmEffect.val > 0) then
                hskill.damage({
                    fromUnit = bean.fromUnit,
                    toUnit = bean.toUnit,
                    damage = unarmEffect.val,
                    realDamage = unarmEffect.val,
                    realDamageString = '缴械',
                    huntKind = "special",
                    huntType = { "magic" },
                })
            end
            if (unarmEffect.model ~= nil) then
                heffect.toUnit(unarmEffect.model, bean.toUnit, "origin", 0.5)
            end
        end
        -- 缚足
        if (isFetter) then
            hattr.set(bean.toUnit, fetterEffect.during, {
                move = '-1000'
            })
            if (fetterEffect.val > 0) then
                hskill.damage({
                    fromUnit = bean.fromUnit,
                    toUnit = bean.toUnit,
                    damage = fetterEffect.val,
                    realDamage = fetterEffect.val,
                    realDamageString = '缚足',
                    huntKind = "special",
                    huntType = { "magic" },
                })
            end
            if (fetterEffect.model ~= nil) then
                heffect.toUnit(fetterEffect.model, bean.toUnit, "origin", 0.5)
            end
            -- @触发缚足事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.fetter,
                triggerUnit = bean.fromUnit,
                targetUnit = bean.toUnit,
                damage = fetterEffect.val,
                percent = fetterEffect.odds,
                during = fetterEffect.during,
            })
            -- @触发被缚足事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.beFetter,
                triggerUnit = bean.toUnit,
                sourceUnit = bean.fromUnit,
                damage = fetterEffect.val,
                percent = fetterEffect.odds,
                during = fetterEffect.during,
            })
        end
        -- 爆破
        if (isBomb) then
            if (bombEffect.val > 0) then
                local tempGroup = hgroup.createByUnit(bean.toUnit, bombEffect.range, function()
                    local flag = true
                    if (his.ally(whichUnit, cj.GetFilterUnit())) then
                        flag = false
                    end
                    if (his.death(cj.GetFilterUnit())) then
                        flag = false
                    end
                    if (his.building(cj.GetFilterUnit())) then
                        flag = false
                    end
                    return flag
                end)
                -- @触发爆破事件
                hevent.triggerEvent({
                    triggerKey = heventKeyMap.bomb,
                    triggerUnit = bean.fromUnit,
                    targetUnit = bean.toUnit,
                    damage = bombEffect.val,
                    percent = bombEffect.odds,
                    range = bombEffect.range,
                })
                cj.ForGroup(tempGroup, function()
                    hskill.damage({
                        fromUnit = bean.fromUnit,
                        toUnit = cj.GetEnumUnit(),
                        damage = bombEffect.val,
                        realDamage = bombEffect.val,
                        huntKind = "special",
                        huntType = { "real" },
                    })
                    -- @触发被爆破事件
                    hevent.triggerEvent({
                        triggerKey = heventKeyMap.beBomb,
                        triggerUnit = cj.GetEnumUnit(),
                        sourceUnit = bean.fromUnit,
                        damage = bombEffect.val,
                        percent = bombEffect.odds,
                        range = bombEffect.range,
                    })
                end)
                cj.GroupClear(tempGroup)
                cj.DestroyGroup(tempGroup)
            end
            if (bombEffect.model ~= nil) then
                heffect.toUnit(bombEffect.model, bean.toUnit, "origin", 0.5)
            end
        end
        -- 闪电链
        if (isLightningChain) then
            hskill.lightningChain(bean.model, lightningChainEffect.qty, lightningChainEffect.reduce, lightningChainEffect.range, false, {
                fromUnit = bean.fromUnit,
                toUnit = bean.toUnit,
                damage = lightningChainEffect.val,
            })
            -- @触发闪电链事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.lightningChain,
                triggerUnit = bean.fromUnit,
                targetUnit = bean.toUnit,
                damage = lightningChainEffect.val,
                percent = lightningChainEffect.odds,
                range = lightningChainEffect.range,
                qty = lightningChainEffect.qty,
            })
        end
        -- 击飞
        if (isCrackFly) then
            hskill.crackFly(crackFlyEffect.distance, crackFlyEffect.high, crackFlyEffect.during, {
                fromUnit = bean.fromUnit,
                toUnit = bean.toUnit,
                damage = crackFlyEffect.val,
                huntEff = crackFlyEffect.model,
                huntKind = "special",
                huntType = { "physical" },
            });
            if (crackFlyEffect.model ~= nil) then
                heffect.toUnit(crackFlyEffect.model, bean.toUnit, "origin", 0.5)
            end
            -- @触发击飞事件
            hevent.triggerEvent({
                triggerKey = heventKeyMap.crackFly,
                triggerUnit = bean.fromUnit,
                targetUnit = bean.toUnit,
                damage = crackFlyEffect.val,
                percent = crackFlyEffect.odds,
                high = crackFlyEffect.high,
                distance = crackFlyEffect.distance,
            })
        end
    end
end

return hattr
