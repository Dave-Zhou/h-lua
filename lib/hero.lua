local hhero = {
    trigger_hero_lvup = nil,
    primary = {
        STR = "力量",
        AGI = "敏捷",
        INT = "智力",
    },
    player_allow_qty = {}, -- 玩家最大单位数量,默认1
    player_current_qty = {}, -- 玩家当前单位数量,默认0
    player_units = {}, -- 玩家当前单位
    build_token = hslk_global.unit_hero_tavern_token,
    build_params = { id = hslk_global.unit_hero_tavern, x = 0, y = 0, distance = 128.0, per_row = 2, allow_qty = 11 },
    hero_born_params = { x = 250, y = 250 }
}
for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
    local p = cj.Player(i - 1)
    hhero.player_allow_qty[p] = 1
    hhero.player_current_qty[p] = 0
    hhero.player_units[p] = {}
end
--- 初始化英雄升级触发器
hhero.trigger_hero_lvup = cj.CreateTrigger()
cj.TriggerAddAction(hhero.trigger_hero_lvup, function()
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
    if (hRuntime.hero[u] == nil) then
        hRuntime.hero[u] = {}
    end
    hRuntime.hero[u].prevLevel = lv
end
--- 获取英雄之前的等级
hhero.getPrevLevel = function(u)
    if (hRuntime.hero[u] == nil) then
        hRuntime.hero[u] = {}
    end
    return hRuntime.hero[u].prevLevel or 0
end
--- 设定酒馆参数
hhero.setBuildParams = function(x, y, distance, per_row, allow_qty)
    hhero.build_params.x = x
    hhero.build_params.y = y
    hhero.build_params.distance = distance
    hhero.build_params.per_row = per_row
    hhero.build_params.allow_qty = allow_qty
end
--- 设定英雄创建参数
hhero.setHeroBornParams = function(x, y)
    hhero.hero_born_params.x = x
    hhero.hero_born_params.y = y
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
hhero.addPlayerUnit = function(whichPlayer, sItem, type)
    if (sItem ~= nil) then
        hhero.player_current_qty[whichPlayer] = hhero.player_current_qty[whichPlayer] + 1
        local u
        if (type == 'click') then
            -- 点击方式
            u = sItem
            hRuntime.heroBuildSelection[u].canSelect = false
            cj.SetUnitOwner(u, whichPlayer, true)
            local loc = cj.Location(hhero.hero_born_params.x, hhero.hero_born_params.y)
            cj.SetUnitPositionLoc(u, loc)
            cj.RemoveLocation(loc)
            cj.PauseUnit(u, false)
        elseif (type == 'tavern') then
            -- 酒馆方式(单位ID)
            u = hunit.create({
                whichPlayer = whichPlayer,
                unitId = sItem,
                x = hhero.hero_born_params.x,
                y = hhero.hero_born_params.y,
            })
            if (hhero.player_current_qty[whichPlayer] >= hhero.player_allow_qty[whichPlayer]) then
                hmessage.echoXY0(whichPlayer, "您选择了 " .. "|cffffff80" .. cj.GetUnitName(u) .. "|r,已挑选完毕", 0)
            else
                hmessage.echoXY0(whichPlayer, "您选择了 " .. "|cffffff80" .. cj.GetUnitName(u) .. "|r,还要选 " .. math.floor(hhero.player_allow_qty[whichPlayer] - hhero.player_current_qty[whichPlayer]) .. " 个", 0)
            end
        end
        if (u == nil) then
            hmessage.echoXY0(whichPlayer, "hhero.addPlayerUnit类型错误", 0)
            return
        end
        table.insert(hhero.player_units[whichPlayer], u)
        hhero.setIsHero(u, true)
        cj.SetUnitInvulnerable(u, false)
        -- 触发英雄被选择事件(全局)
        hevent.triggerEvent({
            triggerKey = heventKeyMap.pickHero,
            triggerHandle = hevent.defaultHandle,
            triggerPlayer = whichPlayer,
            triggerUnit = u,
        })
    end
end
--- 删除一个单位对玩家
hhero.removePlayerUnit = function(whichPlayer, u, type)
    hsystem.rmArray(u, hhero.player_units[whichPlayer])
    hhero.player_current_qty[whichPlayer] = hhero.player_current_qty[whichPlayer] - 1
    if (type == 'click') then
        -- 点击方式
        local heroId = cj.GetUnitTypeId(u)
        local x = hRuntime.heroBuildSelection[u].x
        local y = hRuntime.heroBuildSelection[u].y
        hRuntime.heroBuildSelection[u] = nil
        hunit.del(u, 0)
        local u_new = hunit.create({
            whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
            unitId = heroId,
            x = x,
            y = y,
            isPause = true,
        })
        hRuntime.heroBuildSelection[u_new] = {
            x = x,
            x = y,
            canChoose = true,
        }
    elseif (type == 'tavern') then
        -- 酒馆方式
        local heroId = cj.GetUnitTypeId(u)
        local itemId = hRuntime.heroBuildSelection[heroId].itemId
        local tavern = hRuntime.heroBuildSelection[heroId].tavern
        hunit.del(u, 0)
        cj.AddItemToStock(tavern, itemId, 1, 1)
    end
end
--- 设置一个单位是否使用英雄判定
-- 请不要乱设置[一般单位]为[英雄]，以致于力量敏捷智力等不属于一般单位的属性引起崩溃报错
-- 设定后 his.hero 方法会认为单位为英雄，同时属性系统才会认定它为英雄，从而生效
hhero.setIsHero = function(u, flag)
    hRuntime.is[u].isHero = flag
end
--- 获取英雄的类型（STR AGI INT）
hhero.getHeroType = function(u)
    return hslk_global.heroesKV[cj.GetUnitTypeId(u)].Primary
end
--- 获取英雄的类型文本（力 敏 智）
hhero.getHeroTypeLabel = function(u)
    return hhero.primary[hhero.getHeroType(u)]
end

--- 构建选择单位给玩家（clickQty 击）
hhero.buildClick = function(during, clickQty)
    if (during <= 20) then
        print("建立点击选英雄模式必须设定during大于20秒")
        return
    end
    if (clickQty == nil or clickQty <= 1) then
        clickQty = 2
    end
    during = during + 1
    -- build
    local randomChooseAbleList = {}
    local totalRow = 1
    local rowNowQty = 0
    local x = 0
    local y = 0
    for k, v in pairs(hslk_global.heroes) do
        local heroId = v.heroID
        if (heroId > 0) then
            if (rowNowQty >= hhero.build_params.per_row) then
                rowNowQty = 0
                totalRow = totalRow + 1
                x = hhero.build_params.x
                y = y - hhero.build_params.distance
            else
                x = hhero.build_params.x + rowNowQty * hhero.build_params.distance
            end
            local u = hunit.create({
                whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                unitId = heroId,
                x = x,
                y = y,
                during = during,
                isInvulnerable = true,
                isPause = true,
            })
            hRuntime.heroBuildSelection[u] = {
                x = x,
                x = y,
                canChoose = true,
            }
            table.insert(randomChooseAbleList, u)
            rowNowQty = rowNowQty + 1
        end
    end
    -- evt
    local tgr_random = cj.CreateTrigger()
    local tgr_repick = cj.CreateTrigger()
    local tgr_click = hevent.onSelection(nil, clickQty, function()
        local p = hevent.getTriggerPlayer()
        local u = hevent.getTriggerUnit()
        if (hRuntime.heroBuildSelection[u] == nil) then
            return
        end
        if (hRuntime.heroBuildSelection[u].canSelect == false) then
            return
        end
        if (cj.GetOwningPlayer(u) ~= cj.Player(PLAYER_NEUTRAL_PASSIVE)) then
            return
        end
        if (hhero.player_current_qty[p] >= hhero.player_allow_qty[p]) then
            hmessage.echoXY0(p, "|cffffff80你已经选够了|r", 0)
            return
        end
        hsystem.rmArray(u, randomChooseAbleList)
        hhero.addPlayerUnit(p, u, 'click')
        if (hhero.player_current_qty[p] >= hhero.player_allow_qty[p]) then
            hmessage.echoXY0(p, "您选择了 " .. "|cffffff80" .. cj.GetUnitName(u) .. "|r,已挑选完毕", 0)
        else
            hmessage.echoXY0(p, "您选择了 " .. "|cffffff80" .. cj.GetUnitName(u) .. "|r,还要选 " .. math.floor(hhero.player_allow_qty[p] - hhero.player_current_qty[p]) .. " 个", 0)
        end
    end)
    cj.TriggerAddAction(tgr_random, function()
        local p = cj.GetTriggerPlayer()
        if (hhero.player_current_qty[p] >= hhero.player_allow_qty[p]) then
            hmessage.echoXY0(p, "|cffffff80你已经选够了|r", 0)
            return
        end
        local txt = ""
        local qty = 0
        while (true) do
            local u = hsystem.randTable(randomChooseAbleList)
            hsystem.rmArray(u, randomChooseAbleList)
            txt = txt .. " " .. cj.GetUnitName(u)
            hhero.addPlayerUnit(p, u, 'click')
            hhero.player_current_qty[p] = hhero.player_current_qty[p] + 1
            qty = qty + 1
            if (hhero.player_current_qty[p] >= hhero.player_allow_qty[p]) then
                break
            end
        end
        hmessage.echoXY0(p, "已为您 |cffffff80random|r 选择了 "
                .. "|cffffff80"
                .. math.floor(qty)
                .. "|r 个单位：|cffffff80"
                .. txt
                .. "|r", 0)
    end)
    cj.TriggerAddAction(tgr_repick, function()
        local p = hevent.getTriggerPlayer()
        if (hhero.player_current_qty[p] <= 0) then
            hmessage.echoXY0(p, "|cffffff80你还没有选过任何单位|r", 0)
            return
        end
        local qty = #hhero.player_units
        for k, v in pairs(hhero.player_units[p]) do
            hhero.removePlayerUnit(p, v, 'click')
            table.insert(randomChooseAbleList, v)
        end
        hhero.player_units[p] = {}
        hhero.player_current_qty[p] = 0
        hcamera.toXY(p, 0, hhero.build_params.x, hhero.build_params.y)
        hmessage.echoXY0(p, "已为您 |cffffff80repick|r 了 " .. "|cffffff80" .. qty .. "|r 个单位", 0)
    end)
    -- token
    for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
        local p = cj.Player(i - 1)
        local u = hunit.create({
            whichPlayer = p,
            unitId = hhero.build_token,
            x = hhero.build_params.x + hhero.build_params.per_row * 0.5 * hhero.build_params.distance,
            y = hhero.build_params.y - totalRow * 0.5 * hhero.build_params.distance,
            during = during,
            isInvulnerable = true,
            isPause = true,
        })
        hunit.del(u, during)
        cj.TriggerRegisterPlayerChatEvent(tgr_random, p, "-random", true)
        cj.TriggerRegisterPlayerChatEvent(tgr_repick, p, "-repick", true)
    end
    -- 还剩10秒给个选英雄提示
    htime.setTimeout(during - 10.0, nil, function(t, td)
        local x1 = hhero.build_params.x + hhero.build_params.per_row * 0.5 * hhero.build_params.distance
        local y1 = hhero.build_params.y - totalRow * 0.5 * hhero.build_params.distance
        htime.delDialog(td)
        htime.delTimer(t)
        cj.DisableTrigger(tgr_repick)
        cj.DestroyTrigger(tgr_repick)
        hmessage.echo("还剩 10 秒，还未选择的玩家尽快啦～")
        cj.PingMinimapEx(x1, y1, 1.00, 254, 0, 0, true)
    end)
    -- 一定时间后clear
    htime.setTimeout(during - 0.5, '选择英雄', function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.DisableTrigger(tgr_random)
        cj.DestroyTrigger(tgr_random)
        cj.DisableTrigger(tgr_click)
        cj.DestroyTrigger(tgr_click)
    end)
    -- 转移玩家镜头
    hcamera.toXY(nil, 0, hhero.build_params.x, hhero.build_params.y)
end

--- 构建选择单位给玩家（商店物品）
hhero.buildTavern = function(during)
    if (during <= 20) then
        print("建立酒馆选英雄模式必须设定during大于20秒")
        return
    end
    during = during + 1
    local randomChooseAbleList = {}
    -- evt
    local tgr_sell = cj.CreateTrigger()
    local tgr_random = cj.CreateTrigger()
    local tgr_repick = cj.CreateTrigger()
    cj.TriggerAddAction(tgr_sell, function()
        local it = cj.GetSoldItem()
        local itemId = cj.GetItemTypeId(it)
        local p = cj.GetOwningPlayer(cj.GetBuyingUnit())
        local unitId = hRuntime.heroBuildSelection[itemId].unitId
        local tavern = hRuntime.heroBuildSelection[itemId].tavern
        if (unitId == nil or tavern == nil) then
            print("hhero.buildTavern-tgr_sell=nil")
            return
        end
        if (hhero.player_current_qty[p] >= hhero.player_allow_qty[p]) then
            hmessage.echoXY0(p, "|cffffff80你已经选够了|r", 0)
            hitem.del(it, 0)
            cj.AddItemToStock(tavern, itemId, 1, 1)
            return
        end
        hhero.player_current_qty[p] = hhero.player_current_qty[p] + 1
        cj.RemoveItemFromStock(tavern, itemId)
        hsystem.rmArray(itemId, randomChooseAbleList)
        hhero.addPlayerUnit(p, unitId, 'tavern')
    end)
    cj.TriggerAddAction(tgr_random, function()
        local p = cj.GetTriggerPlayer()
        if (hhero.player_current_qty[p] >= hhero.player_allow_qty[p]) then
            hmessage.echoXY0(p, "|cffffff80你已经选够了|r", 0)
            return
        end
        local txt = ""
        local qty = 0
        while (true) do
            local itemId = hsystem.randTable(randomChooseAbleList)
            hsystem.rmArray(itemId, randomChooseAbleList)
            local unitId = hRuntime.heroBuildSelection[itemId].unitId
            local tavern = hRuntime.heroBuildSelection[itemId].tavern
            if (unitId == nil or tavern == nil) then
                print("hhero.buildTavern-tgr_random=nil")
                return
            end
            txt = txt .. " " .. hslk_global.heroesKV[unitId].Name
            hhero.addPlayerUnit(p, unitId, 'tavern')
            hhero.player_current_qty[p] = hhero.player_current_qty[p] + 1
            qty = qty + 1
            if (hhero.player_current_qty[p] >= hhero.player_allow_qty[p]) then
                break
            end
        end
        hmessage.echoXY0(p, "已为您 |cffffff80random|r 选择了 "
                .. "|cffffff80"
                .. math.floor(qty)
                .. "|r 个单位：|cffffff80"
                .. txt
                .. "|r", 0)
    end)
    cj.TriggerAddAction(tgr_repick, function()
        local p = hevent.getTriggerPlayer()
        if (hhero.player_current_qty[p] <= 0) then
            hmessage.echoXY0(p, "|cffffff80你还没有选过任何单位|r", 0)
            return
        end
        local qty = #hhero.player_units
        for k, v in pairs(hhero.player_units[p]) do
            local heroId = cj.GetUnitTypeId(v)
            hhero.removePlayerUnit(p, v, 'tavern')
            table.insert(randomChooseAbleList, hRuntime.heroBuildSelection[heroId].itemId)
        end
        hhero.player_units[p] = {}
        hhero.player_current_qty[p] = 0
        hcamera.toXY(p, 0, hhero.build_params.x, hhero.build_params.y)
        hmessage.echoXY0(p, "已为您 |cffffff80repick|r 了 " .. "|cffffff80" .. qty .. "|r 个单位", 0)
    end)
    -- build
    local totalRow = 1
    local rowNowQty = 0
    local x = 0
    local y = hhero.build_params.y
    local tavern
    local tavernNowQty = {}
    for k, v in pairs(hslk_global.heroesItems) do
        local itemId = v.itemID
        local heroId = v.heroID
        if (itemID > 0 and heroId > 0) then
            if (tavern == nil or tavernNowQty[tavern] == nil or tavernNowQty[tavern] >= hhero.build_params.allow_qty) then
                tavernNowQty[tavern] = 0
                if (rowNowQty >= hhero.build_params.per_row) then
                    rowNowQty = 0
                    totalRow = totalRow + 1
                    x = hhero.build_params.x
                    y = y - hhero.build_params.distance
                else
                    x = hhero.build_params.x + rowNowQty * hhero.build_params.distance
                end
                tavern = hunit.create({
                    whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                    unitId = hhero.build_params.id,
                    x = x,
                    y = y,
                    during = during,
                })
                cj.SetItemTypeSlots(tavern, hhero.build_params.allow_qty)
                cj.TriggerRegisterUnitEvent(tgr_sell, tavern, EVENT_UNIT_SELL_ITEM)
                rowNowQty = rowNowQty + 1
            end
            tavernNowQty[tavern] = tavernNowQty[tavern] + 1
            cj.AddItemToStock(tavern, itemId, 1, 1)
            hRuntime.heroBuildSelection[itemId] = {
                heroId = heroId,
                tavern = tavern,
            }
            hRuntime.heroBuildSelection[heroId] = {
                itemId = itemId,
                tavern = tavern,
            }
            table.insert(randomChooseAbleList, itemId)
        end
    end
    -- token
    for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
        local p = cj.Player(i - 1)
        local u = hunit.create({
            whichPlayer = p,
            unitId = hhero.build_token,
            x = hhero.build_params.x + hhero.build_params.per_row * 0.5 * hhero.build_params.distance,
            y = hhero.build_params.y - totalRow * 0.5 * hhero.build_params.distance,
            isPause = true,
        })
        hunit.del(u, during)
        cj.TriggerRegisterPlayerChatEvent(tgr_random, p, "-random", true)
        cj.TriggerRegisterPlayerChatEvent(tgr_repick, p, "-repick", true)
    end
    -- 还剩10秒给个选英雄提示
    htime.setTimeout(during - 10.0, nil, function(t, td)
        local x1 = hhero.build_params.x + hhero.build_params.per_row * 0.5 * hhero.build_params.distance
        local y1 = hhero.build_params.y - totalRow * 0.5 * hhero.build_params.distance
        htime.delDialog(td)
        htime.delTimer(t)
        cj.DisableTrigger(tgr_repick)
        cj.DestroyTrigger(tgr_repick)
        hmessage.echo("还剩 10 秒，还未选择的玩家尽快啦～")
        cj.PingMinimapEx(x1, y1, 1.00, 254, 0, 0, true)
    end)
    -- 一定时间后clear
    htime.setTimeout(during - 0.5, '选择英雄', function(t, td)
        htime.delDialog(td)
        htime.delTimer(t)
        cj.DisableTrigger(tgr_random)
        cj.DestroyTrigger(tgr_random)
        cj.DisableTrigger(tgr_sell)
        cj.DestroyTrigger(tgr_sell)
    end)
    -- 转移玩家镜头
    hcamera.toXY(nil, 0, hhero.build_params.x, hhero.build_params.y)
end

return hhero