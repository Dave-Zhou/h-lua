hplayerData = {}
hplayer = {
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
    --获取玩家ID，例如：玩家一等于0，玩家三等于2
    index = function(whichPlayer)
        return cj.GetConvertedPlayerId(whichPlayer)
    end,
    --在所有玩家里获取一个随机的英雄
    getRandomHero = function()
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
    end,
}
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
        hplayerData[p].apm = hplayerData[p].apm + 1
    end)
    cj.TriggerAddAction(triggerApmUnit, function()
        local p = cj.GetOwningPlayer(cj.GetTriggerUnit())
        hplayerData[p].apm = hplayerData[p].apm + 1
    end)
    cj.TriggerAddAction(triggerLeave, function()
        local p = cj.GetTriggerPlayer()
        local g
        hplayerData[p].status = p, hplayer.player_status.leave
        hmsg.echo(cj.GetPlayerName(p) + "离开了～")
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
    hevt.onSelectionDouble(null,function ()
        hplayerData[hevt.getTriggerPlayer()].selection = hevt.getTriggerUnit()
    end)
    cj.TriggerAddAction(triggerDeSelection, function()
        hplayerData[cj.GetTriggerPlayer()].selection = nil
    end)
    cj.TriggerAddAction(triggerLSR, function()
        local p = cj.GetTriggerPlayer()
        local d = cj.DialogCreate()
        local b
        local tg
        cj.DialogSetMessage(d, "设定少于比例触发生命源恢复")
        local bValue = {}
        for i = 100, 10, -10 do
            b = cj.DialogAddButton(d, i .. "%", 0)
            bValue[b] = i
        end
        tg = cj.CreateTrigger()
        cj.TriggerAddAction(tg, function()
            local dd = cj.GetClickedDialog()
            local bb = cj.GetClickedButton()
            hmsg.echoTo(p, "已设定生命源触发比例为：|cffffff80" .. bValue[bb] .. "%|r", 0)
            hplayerData[p].lifeSourceRatio = bValue[bb]
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
        cj.DialogSetMessage(d, "设定少于比例触发魔法源恢复")
        local bValue = {}
        for i = 100, 10, -10 do
            b = cj.DialogAddButton(d, i .. "%", 0)
            bValue[b] = i
        end
        tg = cj.CreateTrigger()
        cj.TriggerAddAction(tg, function()
            local dd = cj.GetClickedDialog()
            local bb = cj.GetClickedButton()
            hmsg.echoTo(p, "已设定魔法源触发比例为：|cffffff80" .. bValue[bb] .. "%|r", 0)
            hplayerData[p].manaSourceRatio = bValue[bb]
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
        if(hplayerData[p].isAutoConvert == true)then
            hplayerData[p].isAutoConvert = false
            hmsg.echoTo(GetTriggerPlayer(),"|cffffcc00关闭|r自动换算",0)
        else
            hplayerData[p].isAutoConvert = true
            hmsg.echoTo(GetTriggerPlayer(),"|cffffcc00开启|r自动换算",0)
        end
    end)
    cj.TriggerRegisterAnyUnitEventBJ( triggerApmUnit, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER )
    cj.TriggerRegisterAnyUnitEventBJ( triggerApmUnit, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER )
    cj.TriggerRegisterAnyUnitEventBJ( triggerApmUnit, EVENT_PLAYER_UNIT_ISSUED_ORDER )
    for i=1,16,1 do
        hplayer.players[i] = cj.Player(i-1)
        cj.SetPlayerHandicapXP( hplayer.players[i] , 0 )
        hplayerData[hplayer.players[i]].prevGold = 0
        hplayerData[hplayer.players[i]].prevLumber = 0
        hplayerData[hplayer.players[i]].goldRatio = 100.00
        hplayerData[hplayer.players[i]].lumberRadio = 100.00
        hplayerData[hplayer.players[i]].expRadio = 100.00
        hplayerData[hplayer.players[i]].sellRadio = 50.00
        hplayerData[hplayer.players[i]].lifeSourceRatio = 50.00
        hplayerData[hplayer.players[i]].manaSourceRatio = 50.00
        hplayerData[hplayer.players[i]].isAutoConvert = true
        hplayerData[hplayer.players[i]].apm = 0
        if((cj.GetPlayerController(hplayer.players[i]) == MAP_CONTROL_USER) and (cj.GetPlayerSlotState(hplayer.players[i]) == PLAYER_SLOT_STATE_PLAYING)) then
            hplayer.qty_current = hplayer.qty_current + 1
            hplayerData[hplayer.players[i]].isComputer = false
            hplayerData[hplayer.players[i]].status = hplayer.player_status.gaming
            cj.TriggerRegisterPlayerSelectionEventBJ( triggerApm , hplayer.players[i] , true )
            cj.TriggerRegisterPlayerEventLeave( triggerLeave, hplayer.players[i] )
            cj.TriggerRegisterPlayerKeyEventBJ( triggerApm , hplayer.players[i] , bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_LEFT )
            cj.TriggerRegisterPlayerKeyEventBJ( triggerApm , hplayer.players[i] , bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_RIGHT )
            cj.TriggerRegisterPlayerKeyEventBJ( triggerApm , hplayer.players[i] , bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_DOWN )
            cj.TriggerRegisterPlayerKeyEventBJ( triggerApm , hplayer.players[i] , bj_KEYEVENTTYPE_DEPRESS, bj_KEYEVENTKEY_UP )
            cj.TriggerRegisterPlayerUnitEvent(triggerDeSelection, hplayer.players[i], EVENT_PLAYER_UNIT_DESELECTED, null)
            cj.TriggerRegisterPlayerChatEvent( triggerLSR , hplayer.players[i] , "-lsr" , true)
            cj.TriggerRegisterPlayerChatEvent( triggerMSR , hplayer.players[i] , "-msr" , true)
            cj.TriggerRegisterPlayerChatEvent( triggerConvert , hplayer.players[i] , "-apc" , true)
        else
            hplayerData[hplayer.players[i]].isComputer = true
            hplayerData[hplayer.players[i]].status = hplayer.player_status.none
        end
    end
end