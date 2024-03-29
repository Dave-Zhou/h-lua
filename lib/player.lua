local hplayer = {
    --用户玩家
    players = {},
    --中立敌对
    player_aggressive = cj.Player(PLAYER_NEUTRAL_AGGRESSIVE),
    --中立受害
    player_victim = cj.Player(bj_PLAYER_NEUTRAL_VICTIM),
    --中立特殊
    player_extra = cj.Player(bj_PLAYER_NEUTRAL_EXTRA),
    --中立被动
    player_passive = cj.Player(PLAYER_NEUTRAL_PASSIVE),
    --玩家状态
    player_status = {
        none = "无参与",
        gaming = "游戏中",
        leave = "已离开",
    },
    --用户玩家最大数量
    qty_max = 12,
    --当前玩家数量
    qty_current = 0,
    --换算比率，默认：1000000金 -> 1木
    convert_ratio = 1000000,
}
--- 设置换算比率
hplayer.setConvertRatio = function(ratio)
    hplayer.convert_ratio = ratio
end
--- 获取换算比率
hplayer.getConvertRatio = function()
    return hplayer.convert_ratio
end
--- 获取玩家ID，例如：玩家一等于0，玩家三等于2
hplayer.index = function(whichPlayer)
    return cj.GetConvertedPlayerId(whichPlayer)
end
--- 获取玩家当前选中的单位
hplayer.getSelection = function(whichPlayer)
    return hRuntime.player[whichPlayer].selection or nil
end
--- 获取玩家当前状态
hplayer.getStatus = function(whichPlayer)
    return hRuntime.player[whichPlayer].status or hplayer.player_status.none
end
--- 获取玩家APM
hplayer.getApm = function(whichPlayer)
    return hRuntime.player[whichPlayer].apm or 0
end
--- 在所有玩家里获取一个随机的英雄
hplayer.getRandomHero = function()
    local pi = {}
    for k, v in ipairs(hplayer.players) do
        if (v.status == hplayer.status.gaming) then
            table.insert(pi, k)
        end
    end
    if (#pi <= 0) then
        return nil
    end
    local ri = cj.GetRandomInt(1, #pi)
    return hhero.getPlayerUnit(hplayer.players[pi[ri]], cj.GetRandomInt(1, hhero.getPlayerUnitQty(hplayer.players[pi[ri]])))
end
--- 令玩家失败
hplayer.defeat = function(whichPlayer, tips)
    if (whichPlayer == nil) then
        return
    end
    local g = hgroup.createByRect(cj.GetEntireMapRect(), function()
        return cj.GetOwningPlayer(cj.GetFilterUnit()) == whichPlayer
    end)
    while (cj.IsUnitGroupEmptyBJ(g) ~= true) do
        local u = cj.FirstOfGroup(g)
        cj.GroupRemoveUnit(g, u)
        cj.RemoveUnit(u)
    end
    cj.GroupClear(g)
    cj.DestroyGroup(g)
    if (tips == "" or tips == nil) then
        tips = "失败"
    end
    bj.CustomDefeatBJ(whichPlayer, tips)
end
--- 令玩家胜利
hplayer.victory = function(whichPlayer)
    if (whichPlayer == nil) then
        return
    end
    bj.CustomVictoryBJ(whichPlayer, true, true)
end
--- 玩家设置是否自动将{hAwardConvertRatio}黄金换1木头
hplayer.setIsAutoConvert = function(whichPlayer, b)
    hRuntime.player[whichPlayer].isAutoConvert = b
end
--- 获取玩家是否自动将{hAwardConvertRatio}黄金换1木头
hplayer.getIsAutoConvert = function(whichPlayer)
    return hRuntime.player[whichPlayer].isAutoConvert or false
end
--- 自动寄存超出的黄金数量，如果满转换数值，则返回对应的整数木头
hplayer.getExceedLumber = function(whichPlayer, exceedGold)
    local current = hRuntime.player[whichPlayer].exceed_gold or 0
    local l = 0
    if (current < 0) then
        current = 0
    end
    current = current + exceedGold
    if (current > 10000000) then
        current = 10000000
    end
    -- 如果没有开启，则先寄存着，开启后再换算，但是最多只存1000W
    if (hplayer.getIsAutoConvert(whichPlayer) == true and current >= hplayer.getConvertRatio()) then
        l = math.floor(current / player_convert_ratio)
        current = math.floor(current - l * player_convert_ratio)
    end
    hRuntime.player[whichPlayer].exceed_gold = current
    return l
end
--- 获取玩家造成的总伤害
hplayer.getDamage = function(whichPlayer)
    return hRuntime.player[whichPlayer].damage or 0
end
--- 增加玩家造成的总伤害
hplayer.addDamage = function(whichPlayer, val)
    hRuntime.player[whichPlayer].damage = hRuntime.player[whichPlayer].damage + val
end
--- 获取玩家受到的总伤害
hplayer.getBeDamage = function(whichPlayer)
    return hRuntime.player[whichPlayer].beDamage or 0
end
--- 增加玩家受到的总伤害
hplayer.addBeDamage = function(whichPlayer, val)
    hRuntime.player[whichPlayer].beDamage = hRuntime.player[whichPlayer].beDamage + val
end
--- 获取玩家杀敌数
hplayer.getBeDamage = function(whichPlayer)
    return hRuntime.player[whichPlayer].kill or 0
end
--- 增加玩家杀敌数
hplayer.addBeDamage = function(whichPlayer, val)
    hRuntime.player[whichPlayer].kill = hRuntime.player[whichPlayer].kill + val
end
--- 获取玩家生命源设定百分比
hplayer.getLifeSourceRatio = function(whichPlayer)
    return hRuntime.player[whichPlayer].lifeSourceRatio
end
--- 获取玩家魔法源设定百分比
hplayer.getManaSourceRatio = function(whichPlayer)
    return hRuntime.player[whichPlayer].manaSourceRatio
end

--- 黄金比率
hplayer.diffGoldRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hRuntime.player[whichPlayer].goldRatio = hRuntime.player[whichPlayer].goldRatio + diff
        if (during > 0) then
            htime.setTimeout(during, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                hRuntime.player[whichPlayer].goldRatio = hRuntime.player[whichPlayer].goldRatio - diff
            end)
        end
    end
end
hplayer.setGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, val - hRuntime.player[whichPlayer].goldRatio, during)
end
hplayer.addGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, val, during)
end
hplayer.subGoldRatio = function(whichPlayer, val, during)
    hplayer.diffGoldRatio(whichPlayer, -val, during)
end
hplayer.getGoldRatio = function(whichPlayer)
    return hRuntime.player[whichPlayer].goldRatio
end

--- 木头比率
hplayer.diffLumberRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hRuntime.player[whichPlayer].lumberRatio = hRuntime.player[whichPlayer].lumberRatio + diff
        if (during > 0) then
            htime.setTimeout(during, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                hRuntime.player[whichPlayer].lumberRatio = hRuntime.player[whichPlayer].lumberRatio - diff
            end)
        end
    end
end
hplayer.setLumberRatio = function(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, val - hRuntime.player[whichPlayer].lumberRatio, during)
end
hplayer.addLumberRatio = function(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, val, during)
end
hplayer.subLumberRatio = function(whichPlayer, val, during)
    hplayer.diffLumberRatio(whichPlayer, -val, during)
end
hplayer.getLumberRatio = function(whichPlayer)
    return hRuntime.player[whichPlayer].lumberRatio
end

--- 经验比率
hplayer.diffExpRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hRuntime.player[whichPlayer].expRatio = hRuntime.player[whichPlayer].expRatio + diff
        if (during > 0) then
            htime.setTimeout(during, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                hRuntime.player[whichPlayer].expRatio = hRuntime.player[whichPlayer].expRatio - diff
            end)
        end
    end
end
hplayer.setExpRatio = function(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, val - hRuntime.player[whichPlayer].expRatio, during)
end
hplayer.addExpRatio = function(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, val, during)
end
hplayer.subExpRatio = function(whichPlayer, val, during)
    hplayer.diffExpRatio(whichPlayer, -val, during)
end
hplayer.getExpRatio = function(whichPlayer)
    return hRuntime.player[whichPlayer].expRatio
end

--- 售卖比率
hplayer.diffSellRatio = function(whichPlayer, diff, during)
    if (diff ~= 0) then
        hRuntime.player[whichPlayer].sellRatio = hRuntime.player[whichPlayer].sellRatio + diff
        if (during > 0) then
            htime.setTimeout(during, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                hRuntime.player[whichPlayer].sellRatio = hRuntime.player[whichPlayer].sellRatio - diff
            end)
        end
    end
end
hplayer.setSellRatio = function(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, val - hRuntime.player[whichPlayer].sellRatio, during)
end
hplayer.addSellRatio = function(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, val, during)
end
hplayer.subSellRatio = function(whichPlayer, val, during)
    hplayer.diffSellRatio(whichPlayer, -val, during)
end
hplayer.getSellRatio = function(whichPlayer)
    return hRuntime.player[whichPlayer].sellRatio
end

--- 玩家总获金量
hplayer.getTotalGold = function(whichPlayer)
    return hRuntime.player[whichPlayer].totalGold
end
hplayer.addTotalGold = function(whichPlayer, val)
    hRuntime.player[whichPlayer].totalGold = hRuntime.player[whichPlayer].totalGold + val
end
--- 玩家总耗金量
hplayer.getTotalGoldCost = function(whichPlayer)
    return hRuntime.player[whichPlayer].totalGoldCost
end
hplayer.addTotalGoldCost = function(whichPlayer, val)
    hRuntime.player[whichPlayer].totalGoldCost = hRuntime.player[whichPlayer].totalGoldCost + val
end

--- 玩家总获木量
hplayer.getTotalLumber = function(whichPlayer)
    return hRuntime.player[whichPlayer].totalLumber
end
hplayer.addTotalLumber = function(whichPlayer, val)
    hRuntime.player[whichPlayer].totalLumber = hRuntime.player[whichPlayer].totalLumber + val
end
--- 玩家总耗木量
hplayer.getTotalLumberCost = function(whichPlayer)
    return hRuntime.player[whichPlayer].totalLumberCost
end
hplayer.addTotalLumberCost = function(whichPlayer, val)
    hRuntime.player[whichPlayer].totalLumberCost = hRuntime.player[whichPlayer].totalLumberCost + val
end

--- 核算玩家金钱
hplayer.adjustGold = function(whichPlayer)
    local prvSys = hRuntime.player[whichPlayer].prevGold
    local relSys = cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD)
    if (prvSys > relSys) then
        hplayer.addTotalGoldCost(whichPlayer, prvSys - relSys)
    elseif (prvSys < relSys) then
        hplayer.addTotalGold(whichPlayer, relSys - prvSys)
    end
    hRuntime.player[whichPlayer].prevGold = relSys
end
--- 核算玩家木头
hplayer.adjustLumber = function(whichPlayer)
    local prvSys = hRuntime.player[whichPlayer].prevLumber
    local relSys = cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
    if (prvSys > relSys) then
        hplayer.addTotalLumberCost(whichPlayer, prvSys - relSys)
    elseif (prvSys < relSys) then
        hplayer.addTotalLumber(whichPlayer, relSys - prvSys)
    end
    hRuntime.player[whichPlayer].prevLumber = relSys
end

--- 获取玩家实时金钱
hplayer.getGold = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD)
end
--- 设置玩家实时金钱
hplayer.setGold = function(whichPlayer, gold)
    local exceedLumber = 0
    -- 满 100W 调用自动换算（至于换不换算，看玩家有没有开转换）
    if (gold > 1000000) then
        exceedLumber = hplayer.getExceedLumber(whichPlayer, gold - 1000000)
        if (hplayer.getIsAutoConvert(whichPlayer) == true) then
            if (exceedLumber > 0) then
                cj.SetPlayerStateBJ(whichPlayer, PLAYER_STATE_RESOURCE_GOLD, cj.SetPlayerStateBJ(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER) + exceedLumber)
                hplayer.adjustLumber(whichPlayer)
            end
        end
        gold = 1000000
    end
    cj.SetPlayerStateBJ(whichPlayer, PLAYER_STATE_RESOURCE_GOLD, gold)
    hplayer.adjustGold(whichPlayer)
end
--- 增加玩家金钱
hplayer.addGold = function(whichPlayer, gold)
    hplayer.setGold(hplayer.getGold(whichPlayer) + gold)
end
--- 减少玩家金钱
hplayer.subGold = function(whichPlayer, gold)
    hplayer.setGold(hplayer.getGold(whichPlayer) - gold)
end

--- 获取玩家实时木头
hplayer.getLumber = function(whichPlayer)
    return cj.GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER)
end
--- 设置玩家实时木头
hplayer.setLumber = function(whichPlayer, lumber)
    cj.SetPlayerStateBJ(whichPlayer, PLAYER_STATE_RESOURCE_LUMBER, lumber)
    hplayer.adjustLumber(whichPlayer)
end
--- 增加玩家木头
hplayer.addLumber = function(whichPlayer, lumber)
    hplayer.setLumber(hplayer.getLumber(whichPlayer) + lumber)
end
--- 减少玩家木头
hplayer.subLumber = function(whichPlayer, lumber)
    hplayer.setLumber(hplayer.getLumber(whichPlayer) - lumber)
end


-- 初始化
hplayerInit = function()
    local triggerApm = cj.CreateTrigger()
    local triggerApmUnit = cj.CreateTrigger()
    local triggerLeave = cj.CreateTrigger()
    local triggerDeSelection = cj.CreateTrigger()
    local triggerLSR = cj.CreateTrigger()
    local triggerMSR = cj.CreateTrigger()
    local triggerConvert = cj.CreateTrigger()
    cj.TriggerAddAction(triggerApm, function()
        local p = cj.GetTriggerPlayer()
        hRuntime.player[p].apm = hRuntime.player[p].apm + 1
    end)
    cj.TriggerAddAction(triggerApmUnit, function()
        local p = cj.GetOwningPlayer(cj.GetTriggerUnit())
        hRuntime.player[p].apm = hRuntime.player[p].apm + 1
    end)
    cj.TriggerAddAction(triggerLeave, function()
        local p = cj.GetTriggerPlayer()
        local g
        hRuntime.player[p].status = p, hplayer.player_status.leave
        hmessage.echo(cj.GetPlayerName(p) .. "离开了～")
        g = hgroup.createByRect(cj.GetEntireMapRect(), function()
            local b = false
            if (cj.GetOwningPlayer(cj.GetFilterUnit()) == p) then
                b = true
            end
            return b
        end)
        while (cj.IsUnitGroupEmptyBJ(g) == false) do
            local u = cj.FirstOfGroup(g)
            cj.GroupRemoveUnit(g, u)
            cj.RemoveUnit(u)
        end
        cj.GroupClear(g)
        cj.DestroyGroup(g)
        hplayer.qty_current = hplayer.qty_current - 1
    end)
    hevent.onSelection(nil, 2, function()
        hRuntime.player[hevent.getTriggerPlayer()].selection = hevent.getTriggerUnit()
    end)
    cj.TriggerAddAction(triggerDeSelection, function()
        hRuntime.player[cj.GetTriggerPlayer()].selection = nil
    end)
    cj.TriggerAddAction(triggerLSR, function()
        local p = cj.GetTriggerPlayer()
        local d = cj.DialogCreate()
        local b
        local tg
        cj.DialogSetMessage(d, "设定某个比例触发生命源恢复")
        local bValue = {}
        for i = 100, 10, -10 do
            b = cj.DialogAddButton(d, i .. "%", 0)
            bValue[b] = i
        end
        tg = cj.CreateTrigger()
        cj.TriggerAddAction(tg, function()
            local dd = cj.GetClickedDialog()
            local bb = cj.GetClickedButton()
            hmessage.echoXY0(p, "已设定生命源触发比例为：|cffffff80" .. bValue[bb] .. "%|r", 0)
            hRuntime.player[p].lifeSourceRatio = bValue[bb]
            cj.DialogClear(dd)
            cj.DialogDestroy(dd)
            cj.DisableTrigger(cj.GetTriggeringTrigger())
            cj.DestroyTrigger(cj.GetTriggeringTrigger())
        end)
        cj.TriggerRegisterDialogEvent(tg, d)
        cj.DialogDisplay(p, d, true)
    end)
    cj.TriggerAddAction(triggerMSR, function()
        local p = cj.GetTriggerPlayer()
        local d = cj.DialogCreate()
        local b
        local tg
        cj.DialogSetMessage(d, "设定某个比例触发魔法源恢复")
        local bValue = {}
        for i = 100, 10, -10 do
            b = cj.DialogAddButton(d, i .. "%", 0)
            bValue[b] = i
        end
        tg = cj.CreateTrigger()
        cj.TriggerAddAction(tg, function()
            local dd = cj.GetClickedDialog()
            local bb = cj.GetClickedButton()
            hmessage.echoXY0(p, "已设定魔法源触发比例为：|cffffff80" .. bValue[bb] .. "%|r", 0)
            hRuntime.player[p].manaSourceRatio = bValue[bb]
            cj.DialogClear(dd)
            cj.DialogDestroy(dd)
            cj.DisableTrigger(cj.GetTriggeringTrigger())
            cj.DestroyTrigger(cj.GetTriggeringTrigger())
        end)
        cj.TriggerRegisterDialogEvent(tg, d)
        cj.DialogDisplay(p, d, true)
    end)
    cj.TriggerAddAction(triggerConvert, function()
        local p = GetTriggerPlayer()
        if (his.autoConvertGoldLumber(p) == true) then
            hRuntime.is[p].isAutoConvertGoldLumber = false
            hmessage.echoXY0(GetTriggerPlayer(), "|cffffcc00关闭|r自动换算", 0)
        else
            hRuntime.is[p].isAutoConvertGoldLumber = true
            hmessage.echoXY0(GetTriggerPlayer(), "|cffffcc00开启|r自动换算", 0)
        end
    end)
    bj.TriggerRegisterAnyUnitEventBJ(triggerApmUnit, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    bj.TriggerRegisterAnyUnitEventBJ(triggerApmUnit, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    bj.TriggerRegisterAnyUnitEventBJ(triggerApmUnit, EVENT_PLAYER_UNIT_ISSUED_ORDER)
    for i = 1, hplayer.qty_max, 1 do
        hplayer.players[i] = cj.Player(i - 1)
        cj.SetPlayerHandicapXP(hplayer.players[i], 0)
        hRuntime.player[hplayer.players[i]].prevGold = 0
        hRuntime.player[hplayer.players[i]].prevLumber = 0
        hRuntime.player[hplayer.players[i]].totalGold = 0
        hRuntime.player[hplayer.players[i]].totalGoldCost = 0
        hRuntime.player[hplayer.players[i]].totalLumber = 0
        hRuntime.player[hplayer.players[i]].totalLumberCost = 0
        hRuntime.player[hplayer.players[i]].goldRatio = 100.00
        hRuntime.player[hplayer.players[i]].lumberRatio = 100.00
        hRuntime.player[hplayer.players[i]].expRatio = 100.00
        hRuntime.player[hplayer.players[i]].sellRatio = 50.00
        hRuntime.player[hplayer.players[i]].lifeSourceRatio = 50.00
        hRuntime.player[hplayer.players[i]].manaSourceRatio = 50.00
        hRuntime.player[hplayer.players[i]].apm = 0
        hRuntime.player[hplayer.players[i]].damage = 0
        hRuntime.player[hplayer.players[i]].beDamage = 0
        hRuntime.player[hplayer.players[i]].kill = 0
        if ((cj.GetPlayerController(hplayer.players[i]) == MAP_CONTROL_USER) and (cj.GetPlayerSlotState(hplayer.players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
            --- his
            hRuntime.is[hplayer.players[i]].isComputer = false
            --
            hplayer.qty_current = hplayer.qty_current + 1
            hRuntime.player[hplayer.players[i]].status = hplayer.player_status.gaming
            bj.TriggerRegisterPlayerSelectionEventBJ(triggerApm, hplayer.players[i], true)
            cj.TriggerRegisterPlayerEvent(triggerLeave, hplayer.players[i], EVENT_PLAYER_LEAVE)
            bj.TriggerRegisterPlayerKeyEventBJ(triggerApm, hplayer.players[i], bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_LEFT)
            bj.TriggerRegisterPlayerKeyEventBJ(triggerApm, hplayer.players[i], bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_RIGHT)
            bj.TriggerRegisterPlayerKeyEventBJ(triggerApm, hplayer.players[i], bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_DOWN)
            bj.TriggerRegisterPlayerKeyEventBJ(triggerApm, hplayer.players[i], bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_UP)
            cj.TriggerRegisterPlayerUnitEvent(triggerDeSelection, hplayer.players[i], EVENT_PLAYER_UNIT_DESELECTED, nil)
            cj.TriggerRegisterPlayerChatEvent(triggerLSR, hplayer.players[i], "-lsr", true)
            cj.TriggerRegisterPlayerChatEvent(triggerMSR, hplayer.players[i], "-msr", true)
            cj.TriggerRegisterPlayerChatEvent(triggerConvert, hplayer.players[i], "-apc", true)
        else
            --- his
            hRuntime.is[hplayer.players[i]].isComputer = true
            --
            hRuntime.player[hplayer.players[i]].status = hplayer.player_status.none
        end
    end
end

return hplayer
