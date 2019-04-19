hisCache = {}
for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
    local p = cj.Player(i - 1)
    hisCache[p] = {}
    hisCache[p].isComputer = true
    hisCache[p].isAutoConvertGoldLumber = true
end
his = {
    --是否夜晚
    night = function()
        return (cj.GetTimeOfDay() <= 6.00 or cj.GetTimeOfDay() >= 18.00)
    end,
    --是否白天
    day = function()
        return (cj.GetTimeOfDay() > 6.00 and cj.GetTimeOfDay() < 18.00)
    end,
    --是否电脑
    computer = function(whichPlayer)
        return hisCache[whichPlayer].isComputer
    end,
    --是否自动换算黄金木头
    autoConvertGoldLumber = function(whichPlayer)
        return hisCache[whichPlayer].isAutoConvertGoldLumber
    end,
    --是否玩家位置(如果位置为真实玩家或为空，则为true；而如果选择了电脑玩家补充，则为false)
    playerSite = function(whichPlayer)
        return cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER
    end,
    --是否正在游戏
    playing = function(whichPlayer)
        return cj.GetPlayerSlotState(whichPlayer) == PLAYER_SLOT_STATE_PLAYING
    end,
    --是否中立玩家（包括中立敌对 中立被动 中立受害 中立特殊）
    neutral = function(whichPlayer)
        local flag = false
        if (whichPlayer == nil) then
            flag = false
        elseif (whichPlayer == cj.Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
            flag = true
        elseif (whichPlayer == cj.Player(bj_PLAYER_NEUTRAL_VICTIM)) then
            flag = true
        elseif (whichPlayer == cj.Player(bj_PLAYER_NEUTRAL_EXTRA)) then
            flag = true
        elseif (whichPlayer == cj.Player(PLAYER_NEUTRAL_PASSIVE)) then
            flag = true
        end
        return flag
    end,
    --是否在某玩家真实视野内
    detected = function(whichUnit, whichPlayer)
        local flag = false
        if (whichUnit == nil or whichPlayer == nil) then
            flag = false
        elseif (cj.IsUnitDetected(whichUnit, whichPlayer) == true) then
            flag = true
        end
        return flag
    end,
    --是否拥有物品栏
    hasSlot = function(whichUnit)
        return cj.GetUnitAbilityLevel(whichUnit, hsystem.ITEM_SKILL) >= 1
    end,
    --是否死亡
    death = function(whichUnit)
        return cj.IsUnitDeadBJ(whichUnit)
    end,
    --是否生存
    alive = function(whichUnit)
        return not his.death(whichUnit)
    end,
    --是否无敌
    invincible = function(whichUnit)
        return cj.GetUnitAbilityLevel(whichUnit, 'Avul') > 0
    end,
    --是否英雄
    hero = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_HERO) or hisCache[whichUnit].isHero == true
    end,
    --是否建筑
    building = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)
    end,
    --是否镜像
    illusion = function(whichUnit)
        return cj.IsUnitIllusion(whichUnit)
    end,
    --是否地面单位
    ground = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_GROUND)
    end,
    --是否空中单位
    flying = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_FLYING)
    end,
    --是否近战
    melee = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
    end,
    --是否远程
    ranged = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)
    end,
    --是否召唤
    summoned = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_SUMMONED)
    end,
    --是否机械
    mechanical = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_MECHANICAL)
    end,
    --是否古树
    ancient = function(whichUnit)
        return cj.IsUnitType(whichUnit, UNIT_TYPE_ANCIENT)
    end,
    --是否被眩晕
    swim = function(whichUnit)
        return (hisCache[whichUnit] and hisCache[whichUnit].isSwim == true) or false
    end,
    --是否被硬直
    punish = function(whichUnit)
        return (hisCache[whichUnit] and hisCache[whichUnit].isPunishing == true) or false
    end,
    --是否被沉默
    silent = function(whichUnit)
        return (hisCache[whichUnit] and hisCache[whichUnit].isSilent == true) or false
    end,
    --是否被缴械
    unarm = function(whichUnit)
        return (hisCache[whichUnit] and hisCache[whichUnit].isUnArm == true) or false
    end,
    --是否被击飞
    crackfly = function(whichUnit)
        return (hisCache[whichUnit] and hisCache[whichUnit].isCrackFly == true) or false
    end,
    --判断是否处在水面
    water = function(whichUnit)
        return cj.IsTerrainPathable(cj.GetUnitX(whichUnit), cj.GetUnitY(whichUnit), PATHING_TYPE_FLOATABILITY) == false
    end,
    --判断是否处于地面
    floor = function(whichUnit)
        return cj.IsTerrainPathable(cj.GetUnitX(whichUnit), cj.GetUnitY(whichUnit), PATHING_TYPE_FLOATABILITY) == true
    end,
    --是否某个特定单位
    unit = function(whichUnit, otherUnit)
        return whichUnit == otherUnit
    end,
    --是否敌人
    enemy = function(whichUnit, otherUnit)
        return cj.IsUnitEnemy(whichUnit, cj.GetOwningPlayer(otherUnit))
    end,
    --是否友军
    ally = function(whichUnit, otherUnit)
        return cj.IsUnitAlly(whichUnit, cj.GetOwningPlayer(otherUnit))
    end,
    --是否超出区域边界
    borderRect = function(r, x, y)
        local flag = false
        if (x >= cj.GetRectMaxX(r) or x <= cj.GetRectMinX(r)) then
            flag = true
        end
        if (y >= cj.GetRectMaxY(r) or y <= cj.GetRectMinY(r)) then
            return true
        end
        return flag
    end,
    --是否超出地图边界
    borderMap = function(x, y)
        return cj.borderRect(cj.GetPlayableMapRect(), x, y)
    end,
    --单位身上是否有某物品
    ownItem = function(u, itemId)
        local f = false
        for i = 0, 5, 1 do
            local it = cj.UnitItemInSlot(u, i)
            if (it ~= nil and cj.GetItemTypeId(it) == itemId) then
                f = true
                break
            end
        end
        return f
    end,
}

