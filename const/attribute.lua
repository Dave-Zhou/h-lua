-- 属性系统

CONST_ATTR = {
    life = "生命",
    mana = "魔法",
    move = "移动",
    defend = "护甲",
    attack_hunt_type = "攻击附魔",
    physical = "物理",
    magic = "魔法",
    real = "真实",
    absolute = "绝对",
    fire = "火",
    soil = "土",
    water = "水",
    ice = "冰",
    wind = "风",
    light = "光",
    dark = "暗",
    wood = "木",
    thunder = "雷",
    poison = "毒",
    ghost = "鬼",
    metal = "金",
    dragon = "龙",
    attack_speed = "攻速",
    attack_speed_space = "攻击间隔",
    attack_white = "物理攻击",
    attack_green = "魔法攻击",
    attack_range = "攻击范围",
    sight = "视野范围",
    str_green = "附加力量",
    agi_green = "附加敏捷",
    int_green = "附加智力",
    str_white = "本体力量",
    agi_white = "本体敏捷",
    int_white = "本体智力",
    life_back = "生命恢复",
    life_source = "生命源",
    life_source_current = "当前生命源",
    mana_back = "魔法恢复",
    mana_source = "魔法源",
    mana_source_current = "当前魔法源",
    resistance = "魔抗",
    toughness = "韧性",
    avoid = "回避",
    aim = "命中",
    knocking = "物理暴击伤害",
    violence = "魔法暴击伤害",
    knocking_odds = "物理暴击几率",
    violence_odds = "魔法暴击几率",
    punish = "僵直",
    punish_current = "当前僵直",
    meditative = "冥想力",
    help = "救助力",
    hemophagia = "吸血",
    hemophagia_skill = "技能吸血",
    split = "分裂",
    split_range = "分裂范围",
    luck = "幸运",
    invincible = "无敌",
    weight = "负重",
    weight_current = "当前负重",
    hunt_amplitude = "伤害增幅",
    hunt_rebound = "反弹伤害",
    cure = "治疗",
    knocking_oppose = "物理暴击抵抗",
    violence_oppose = "魔法暴击抵抗",
    hemophagia_oppose = "吸血抵抗",
    hemophagia_skill_oppose = "技能吸血抵抗",
    split_oppose = "分裂抵抗",
    punish_oppose = "僵直抵抗",
    hunt_rebound_oppose = "反伤抵抗",
    swim_oppose = "眩晕抵抗",
    break_oppose = "打断抵抗",
    silent_oppose = "沉默抵抗",
    unarm_oppose = "缴械抵抗",
    fetter_oppose = "缚足抵抗",
    bomb_oppose = "爆破抵抗",
    lightning_chain_oppose = "闪电链抵抗",
    crack_fly_oppose = "击飞抵抗",
    natural_fire = "自然火攻",
    natural_soil = "自然土攻",
    natural_water = "自然水攻",
    natural_ice = "自然冰攻",
    natural_wind = "自然风攻",
    natural_light = "自然光攻",
    natural_dark = "自然暗攻",
    natural_wood = "自然木攻",
    natural_thunder = "自然雷攻",
    natural_poison = "自然毒攻",
    natural_ghost = "自然鬼攻",
    natural_metal = "自然金攻",
    natural_dragon = "自然龙攻",
    natural_fire_oppose = "自然火抗",
    natural_soil_oppose = "自然土抗",
    natural_water_oppose = "自然水抗",
    natural_ice_oppose = "自然冰抗",
    natural_wind_oppose = "自然风抗",
    natural_light_oppose = "自然光抗",
    natural_dark_oppose = "自然暗抗",
    natural_wood_oppose = "自然风抗",
    natural_thunder_oppose = "自然雷抗",
    natural_poison_oppose = "自然毒抗",
    natural_ghost_oppose = "自然鬼抗",
    natural_metal_oppose = "自然金抗",
    natural_dragon_oppose = "自然龙抗",
    --
    attack_buff = "攻击增益",
    attack_debuff = "攻击负面",
    skill_buff = "技能增益",
    skill_debuff = "技能负面",
    attack_effect = "攻击特效",
    skill_effect = "技能特效",
    --
    swim = "眩晕",
    broken = "眩晕",
    silent = "眩晕",
    unarm = "缴械",
    fetter = "缚足",
    bomb = "爆破",
    lightning_chain = "闪电链",
    crack_fly = "击飞",
    --
    odds = "几率",
    val = "伤害",
    during = "持续时间",
    qty = "数量",
    reduce = "衰减",
    distance = "距离",
    high = "高度",
}

const_getItemDesc = function(attr)
    local str = ""
    for k, v in pairs(attr) do
        if (type(v) ~= "table" and v > 0) then
            v = "+" .. v
        end
        -- 附加单位
        if (k == "attack_speed_space") then
            v = v .. "击每秒"
        end
        if (hSys.inArray(k, { "life_back", "mana_back", })) then
            v = v .. "每秒"
        end
        if (hSys.inArray(k, {
            "resistance", "avoid", "aim",
            "knocking_odds", "violence_odds", "hemophagia", "hemophagia_skill",
            "split", "luck", "invincible",
            "hunt_amplitude", "hunt_rebound", "cure"
        })) then
            v = v .. "%"
        end
        local s = string.find(k, "oppose")
        local n = string.find(k, "natural")
        if (s ~= nil or n ~= nil) then
            v = v .. "%"
        end
        --
        str = str .. CONST_ATTR[k] .. "："
        if (type(v) == "table") then
            local temp = ""
            if (k == "attack_hunt_type") then
                for _, vv in ipairs(v) do
                    if (temp == "") then
                        temp = temp .. CONST_ATTR[vv]
                    else
                        temp = "," .. CONST_ATTR[vv]
                    end
                end
            else
                for kk, vv in ipairs(v) do
                    if (vv > 0) then
                        vv = "+" .. vv
                    end
                    if (kk == "during") then
                        vv = vv .. "秒"
                    end
                    if (kk == "attack_speed_space") then
                        vv = vv .. "击每秒"
                    end
                    if (hSys.inArray(kk, { "life_back", "mana_back", })) then
                        vv = vv .. "每秒"
                    end
                    if (hSys.inArray(kk, {
                        "attack_speed", "resistance", "avoid", "aim",
                        "knocking", "violence", "knocking_odds", "violence_odds",
                        "hemophagia", "hemophagia_skill",
                        "split", "luck", "invincible",
                        "hunt_amplitude", "hunt_rebound", "cure",
                        "odds", "reduce"
                    })) then
                        vv = vv .. "%"
                    end
                    if (temp == "") then
                        temp = temp .. CONST_ATTR[kk] .. "(" .. vv .. ")"
                    else
                        temp = "," .. temp .. CONST_ATTR[kk] .. "(" .. vv .. ")"
                    end
                end
            end
            str = str .. temp
        else
            str = str .. v
        end
        str = str .. "|n"
    end
    return str
end

const_getItemUbertip = function(attr)
    local str = ""
    for k, v in pairs(attr) do
        if (type(v) ~= "table" and v > 0) then
            v = "+" .. v
        end
        str = str .. CONST_ATTR[k] .. ":"
        if (type(v) == "table") then
            local temp = ""
            if (k == "attack_hunt_type") then
                for _, vv in ipairs(v) do
                    if (temp == "") then
                        temp = temp .. CONST_ATTR[vv]
                    else
                        temp = "," .. CONST_ATTR[vv]
                    end
                end
            end
        else
            str = str .. v
        end
        str = str .. ","
    end
    return str
end

