-- [[奖励]]
haward = {
    shareRange = 2000.00
}
-- 设置共享范围
haward.setShareRange = function(range)
    haward.shareRange = hlogic.round(range)
end
-- 奖励单位（经验黄金木头）
haward.forUnit = function(whichUnit, exp, gold, lumber)
    local floatStr = null
    local realExp = exp
    local realGold = gold
    local realLumber = lumber
    local index = 0
    local ttgColorLen = 0
    local ttg = null
    local p = null
    if (whichUnit == nil) then
        return
    end
    floatStr = ""
    index = cj.GetConvertedPlayerId(cj.GetOwningPlayer(whichUnit))
    -- TODO 增益
    p = cj.GetOwningPlayer(whichUnit)
    realGold = cj.R2I(gold * hplayer.getGoldRatio(p) / 100.00)
    realLumber = cj.R2I(lumber * hplayer.getLumberRatio(p) / 100.00)
    realExp = cj.R2I(exp * hplayer.getExpRatio(p) / 100.00)
    if (realExp >= 1 and his.hero(whichUnit)) then
        cj.AddHeroXPSwapped(realExp, whichUnit, true)
        floatStr = floatStr .. "|cffc4c4ff" .. realExp .. "Exp" .. "|r"
        ttgColorLen = ttgColorLen + 12
    end
    if (realGold >= 1) then
        hplayer.addGold(p, realGold)
        floatStr = floatStr .. " |cffffcc00" .. realGold .. "G" .. "|r"
        ttgColorLen = ttgColorLen + 13
        hmedia.soundPlay2Unit(gg_snd_ReceiveGold, whichUnit)
    end
    if (realLumber >= 1) then
        hplayer.addLumber(p, realLumber)
        floatStr = floatStr .. " |cff80ff80" .. realLumber .. "L" .. "|r"
        ttgColorLen = ttgColorLen + 13
        hmedia.soundPlay2Unit(gg_snd_BundleOfLumber, whichUnit)
    end
    ttg = httg.create2Unit(whichUnit, floatStr, 7, "", 0, 1.70, 60.00)
    cj.SetTextTagPos(ttg, cj.GetUnitX(whichUnit) - (string.len(floatStr) - ttgColorLen) * 7 * 0.5, cj.GetUnitY(whichUnit), 50)
    httg.style(ttg, "toggle", 0, 0.23)
end
-- 奖励单位经验
haward.forUnitExp = function(whichUnit, exp)
    return haward.forUnit(whichUnit, exp, 0, 0)
end
-- 奖励单位黄金
haward.forUnitGold = function(whichUnit, gold)
    return haward.forUnit(whichUnit, 0, gold, 0)
end
-- 奖励单位木头
haward.forUnitLumber = function(whichUnit, lumber)
    return haward.forUnit(whichUnit, 0, 0, lumber)
end
--[[
struct hAward
    /**
     * 平分奖励英雄组（经验黄金木头）
     */
    public method forGroup takes unit whichUnit,integer exp,integer gold,integer lumber returns nothing
        local unit u = null
        local group g = null
        local integer gCount = 0
        local integer cutExp = 0
        local integer cutGold = 0
        local integer cutLumber = 0
        local hFilter filter = 0
        set filter = hFilter.create()
        call filter.isHero(true)
        call filter.isAlly(true,whichUnit)
        call filter.isAlive(true)
        call filter.isBuilding(false)
        set g = hgroup.createByUnit(whichUnit,hAwardRange,function hFilter.get)
        call filter.destroy()
        set gCount = CountUnitsInGroup( g )
        if( gCount <=0 ) then
            return
        endif
        set cutExp = R2I(I2R(exp) / I2R(gCount))
        set cutGold = R2I(I2R(gold) / I2R(gCount))
        set cutLumber = R2I(I2R(lumber) / I2R(gCount))
        if(exp > 0 and cutExp<1)then
            set cutExp = 1
        endif
        loop
            exitwhen(IsUnitGroupEmptyBJ(g) == true)
                //must do
                set u = FirstOfGroup(g)
                call GroupRemoveUnit( g , u )
                //
                call forUnit(u,cutExp,cutGold,cutLumber)
                set u = null
        endloop
        call GroupClear(g)
        call DestroyGroup(g)
        set g = null
    endmethod

    /**
     * 平分奖励玩家组（黄金木头）
     */
    public method forPlayer takes integer gold,integer lumber returns nothing
        local integer i = 0
        local integer cutGold = R2I(I2R(gold) / I2R(player_current_qty))
        local integer cutLumber = R2I(I2R(lumber) / I2R(player_current_qty))
        set i = player_max_qty
        loop
            exitwhen(i<=0)
                if(hplayer.getStatus(players[i])==hplayer.default_status_gaming)then
                    call hplayer.addGold(players[i],cutGold)
                    call hplayer.addLumber(players[i],cutLumber)
                endif
            set i=i-1
        endloop
    endmethod

    /**
     * 平分奖励英雄组黄金
     */
    public method forGroupGold takes unit whichUnit,integer gold returns nothing
        call forGroup(whichUnit,0,gold,0)
    endmethod
    /**
     * 平分奖励英雄组木头
     */
    public method forGroupLumber takes unit whichUnit,integer lumber returns nothing
        call forGroup(whichUnit,0,0,lumber)
    endmethod
    /**
     * 平分奖励英雄组经验
     */
    public method forGroupExp takes unit whichUnit,integer exp returns nothing
        call forGroup(whichUnit,exp,0,0)
    endmethod

    /**
     * 平分奖励玩家组黄金
     */
    public method forPlayerGold takes unit whichUnit,integer gold returns nothing
        call forPlayer(gold,0)
    endmethod
    /**
     * 平分奖励玩家组木头
     */
    public method forPlayerLumber takes unit whichUnit,integer lumber returns nothing
        call forPlayer(0,lumber)
    endmethod

endstruct
