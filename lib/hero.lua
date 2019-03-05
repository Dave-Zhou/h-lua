hheroCache = {}
hhero = {
    trigger_hero_lvup = nil,
    primary = {
        STR = "力量",
        AGI = "敏捷",
        INT = "智力",
    },
    player_allow_qty = {}, -- 玩家最大单位数量,默认1
    player_current_qty = {}, -- 玩家当前单位数量,默认1
    player_units = {}, -- 玩家当前单位
    tavern_token = hslk_global.unit_hero_tavern_token,
    tavern_build_params = { id = hslk_global.unit_hero_tavern, x = 0, y = 0, distance = 128.0, per_row = 2, allow_qty = 11 },
    tavern_hero_born_params = { x = 250, y = 250 }
}
for i = 1, #hplayer.qty_max, 1 do
    hhero.player_allow_qty[hplayer.players[i]] = 1
    hhero.player_current_qty[hplayer.players[i]] = 0
    hhero.player_units[hplayer.players[i]] = {}
end
--- 初始化英雄升级触发器
hhero.trigger_hero_lvup = cj.CreateTrigger()
hhero.trigger_hero_lvup.TriggerAddAction(tg, function()
    local u = cj.GetTriggerUnit()
    local diffLv = cj.GetHeroLevel(u) - hhero.getPrevLevel(u)
    print("diffLv=" .. diffLv)
    if (diffLv < 1) then
        return
    end
    hattr.setStrWhite(u, cj.GetHeroStr(u, false), 0)
    hattr.setAgiWhite(u, cj.GetHeroAgi(u, false), 0)
    hattr.setIntWhite(u, cj.GetHeroInt(u, false), 0)
    hattr.addHelp(u, 2 * diffLv, 0)
    hattr.addWeight(u, 0.25 * diffLv, 0)
    hattr.addLifeSource(u, 10 * diffLv, 0)
    hattr.addManaSource(u, 10 * diffLv, 0)
    -- @触发升级事件
    hevt.triggerEvent({
        triggerKey = "levelUp",
        triggerUnit = u,
    })
    hhero.setPrevLevel(u, ch.GetHeroLevel(GetTriggerUnit()))
end)
--- 设置英雄之前的等级
hhero.setPrevLevel = function(u, lv)
    if (hheroCache[u] == nil) then
        hheroCache[u] = {}
    end
    hheroCache[u].prevLevel = lv
end
--- 获取英雄之前的等级
hhero.getPrevLevel = function(u)
    if (hheroCache[u] == nil) then
        hheroCache[u] = {}
    end
    return hheroCache[u].prevLevel or 0
end
--- 设定酒馆参数
hhero.setTavernBuildParams = function(x, y, distance, per_row, allow_qty)
    hhero.tavern_build_params.x = x
    hhero.tavern_build_params.y = y
    hhero.tavern_build_params.distance = distance
    hhero.tavern_build_params.per_row = per_row
    hhero.tavern_build_params.allow_qty = allow_qty
end
--- 设定英雄创建参数
hhero.setTavernHeroBornParams = function(x, y)
    hhero.tavern_hero_born_params.x = x
    hhero.tavern_hero_born_params.y = y
end
--- 设置玩家最大单位数量,支持1 - 7
hhero.setPlayerAllowQty = function(whichPlayer, max)
    if (max > 0 and max <= 7) then
        heros.player_allow_qty[whichPlayer] = max
    else
        print("hhero.setPlayerMaxQty error")
    end
end
--- 获取玩家最大单位数量
hhero.getPlayerAllowQty = function(whichPlayer)
    return heros.player_allow_qty[whichPlayer]
end
--- 添加一个单位给玩家
hhero.addPlayerUnit = function(whichPlayer, u)
    if (u ~= nil) then
        table.insert(hhero.player_units[whichPlayer], u)
        -- 触发英雄被选择事件(全局)
        hevent.triggerEvent({
            triggerKey = "pickHero",
            triggerHandle = hevent.getDefaultHandle(),
            triggerUnit = u,
        })
    end
end
--- 删除一个单位对玩家
hhero.addPlayerUnit = function(whichPlayer, u)
    hsystem.rmArray(u, hhero.player_units[whichPlayer])
end
--- 设置一个单位是否使用英雄判定
-- 请不要乱设置[一般单位]为[英雄]，以致于力量敏捷智力等不属于一般单位的属性引起崩溃报错
-- 设定后 his.hero 方法会认为单位为英雄，同时属性系统才会认定它为英雄，从而生效
hhero.setIsHero = function(u, flag)
    hisCache[u].isHero = flag
end
--- 获取英雄的类型（STR AGI INT）
hhero.getHeroType = function(u)
    return hslk_global.heroesKV[cj.GetUnitTypeId(u)].Primary
end
--- 获取英雄的类型文本（力 敏 智）
hhero.getHeroTypeLabel = function(u)
    return hhero.primary[hhero.getHeroType(u)]
end


